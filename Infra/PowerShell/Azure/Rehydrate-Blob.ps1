<#
.SYNOPSIS
    Rehydrates blobs in an Azure Storage account from the Archive tier to a specified access tier.

.DESCRIPTION
    This script rehydrates blobs in an Azure Storage account from the Archive tier to a specified access tier.
    It supports input from CSV or TXT files containing blob names.

.PARAMETER StorageAccountName
    The name of the Azure Storage account.

.PARAMETER ContainerName
    The name of the container within the Azure Storage account.

.PARAMETER BlobName
    The name of the blob to rehydrate. This parameter can be piped from input.

.PARAMETER InputFile
    The path to the CSV or TXT file containing blob names. If using CSV the header must be 'BlobName'. This parameter can be piped from input.

.PARAMETER AccessTier
    The access tier to which the blobs should be rehydrated (e.g., Hot, Cool. Cold).

.PARAMETER SasToken
    The SAS token for accessing the storage account. If not provided, the script will prompt for OAuth authentication.

.PARAMETER Priority
    The rehydration priority of the blob. Supported values are: Standard and High. Default value is Standard.

.PARAMETER LogFilePath
    The path for the log file (e.g., C:\Logs). If no value is provided the default path will be '$env:USERPROFILE\.rehydrate-blob\'


.EXAMPLE
    .\RehydrateBlobs.ps1 -StorageAccountName "mystorageaccount" -ContainerName "mycontainer" -InputFile "blobs.csv" -AccessTier "Hot" -SasToken "sas token"

.NOTES
    Author: Nicholas Ottaviano
    Date: 2024-09-11
    Version: 1.0
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$StorageAccountName,
    [Parameter(Mandatory=$true)]
    [string]$ContainerName,
    [Parameter(ValueFromPipeline)]
    [string]$InputFile,
    [Parameter(ValueFromPipeline)]
    [string]$AccessTier,
    [Parameter()]
    [string]$SasToken,
    [Parameter()]
    [string]$Priority = "Standard",
    [Parameter()]
    [string]$LogFilePath
)

# Initialize the blobs processed counter
$ProcessedCount = 0

# Generate a timestamp for the log file
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# Set the log file path
if (-not $LogFilePath) {
  $LogFilePath = "$env:USERPROFILE\.rehydrate-blob\RehydrateBlobs_$Timestamp.log"
} else {
  $LogFilePath = "$LogFilePath\RehydrateBlobs_$Timestamp.log"
}

# Create the log directory if it does not exist
$LogDirectory = [System.IO.Path]::GetDirectoryName($LogFilePath)

if (-not (Test-Path -Path $LogDirectory)) {
    New-Item -Path $LogDirectory -ItemType Directory | Out-Null
}

# Function to log messages
function Write-Log {
    param (
        [string]$Message
    )
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "$Timestamp - $Message"
    Add-Content -Path $LogFilePath -Value $LogEntry
}

if ($SasToken) {
  # Create the storage context using the SAS token
$Context = New-AzStorageContext -StorageAccountName $StorageAccountName -SasToken $SasToken
} else {
  # This will prompt the user for an OAuth authentication. Need to fully test still.
$Context = New-AzStorageContext -StorageAccountName $StorageAccountName -UseConnectedAccount
}

# Determine if the file is CSV or TXT
$FileExtension = [System.IO.Path]::GetExtension($InputFile).ToLower()

if ($FileExtension -eq ".csv") {
    # Import the CSV file
    $BlobNames = Import-Csv -Path $InputFile | Select-Object -ExpandProperty BlobName
} elseif ($FileExtension -eq ".txt") {
    # Read the TXT file
    $BlobNames = Get-Content -Path $InputFile
} else {
    Write-Host "Unsupported file type. Please provide a CSV or TXT file."
    return
}


# Rehydrate each blob with the specified rehydration tier
foreach ($Blob in $BlobNames) {

    try {
        # Get the blob properties
        $BlobProperties = Get-AzStorageBlob -Context $Context -Container $ContainerName -Blob $Blob -ErrorAction Stop

        # Check if the blob is in the Archive tier
        if ($BlobProperties.AccessTier -eq "Archive") {
            # Set the rehydration tier for the blob
          $BlobProperties.BlobClient.SetAccessTier("$AccessTier", $null, "$Priority")

          $ProcessedCount++

          Write-Host "Rehydrating blob: $Blob, total blobs processed $ProcessedCount"
        }
      } catch {
          # Log the error if the blob doesn't exist or any other error occurs
          if ($_.Exception.Message -like "*Can not find blob*") {

            $ErrorMessage = "Blob not found: $Blob"

          } else {

            $ErrorMessage = "Error processing blob: $Blob"

          }

          Write-Host $ErrorMessage
          Write-Log -Message $ErrorMessage
      }
    }
