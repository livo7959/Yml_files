Param (
    [string]$SourcePath,
    [string]$DestinationPath1,
    [string]$BuildEnvironment,
    [string]$ApplicationVersion
)

# Define the function PerformReplacement
function PerformReplacement {
    Param (
        [string]$FilePath
    )

    # Define the replacement values
    $ApplicationVersionReplacement = "${ApplicationVersion}"

    # Perform replacements in the file
    (Get-Content $FilePath) | ForEach-Object {
        $_ -replace '\${ApplicationVersion}', $ApplicationVersionReplacement
    } | Set-Content $FilePath
}

# Construct the full paths
$SourceFile = Join-Path $SourcePath "publish.template_$BuildEnvironment.htm"
$DestinationFile1 = Join-Path $DestinationPath1 "$BuildEnvironment\publish.template_$BuildEnvironment.htm"
$FinalDestinationFile = Join-Path $DestinationPath1 "$BuildEnvironment\publish.htm"

# Copy the file to destination2
Copy-Item -Path $SourceFile -Destination $DestinationFile1 -Force

# Perform replacements for destination2
PerformReplacement -FilePath $DestinationFile1

# Check if publish.htm exists in destination and remove it if it does
if (Test-Path $FinalDestinationFile -PathType Leaf) {
    Remove-Item -Path $FinalDestinationFile -Force
}

# Rename the file in destination 1 to publish.htm
Rename-Item -Path $DestinationFile1 -NewName "publish.htm" -Force
