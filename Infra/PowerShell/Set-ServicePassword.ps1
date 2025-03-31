
[CmdletBinding()]
param (
    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
    [string] $Servers,
    [Parameter(Mandatory=$True)]
    [string] $UserName,
    [Parameter()]
    [securestring] $AccountPassword
)

# prompt for credential
$AccountPassword = Get-Credential -Message "Enter Password of service account"

# Loop through each server
foreach ($Server in $Servers) {
    $vstsService= Get-Service -Name *vstsagent* | Select-Object Name

    Set-Service $vstsService -Credential $AccountPassword
}