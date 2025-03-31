<#
.SYNOPSIS
    Lists Azure Active Directory application certificates and secrets that are expiring within a specified number of days.

.DESCRIPTION
    This script checks all App Registrations for expired certificates or secrets depending on the provided arguments.

.PARAMETER DaysBeforeExpiration
    This dictates the time range in days of when any principals will be expiring.
    If set to 0, it will only returned already expired principals.

.PARAMETER OnlySecrets
    Specifying this will only return client secrets. Providing no arguments returns all principals.

.PARAMETER OnlyCertificates
    Specifying this will only return certificates. Providing no arguments returns all principals.

.PARAMETER SmtpServer
    The URL of the SMTP Server. Defaults to relay.logixhealth.com.

.PARAMETER From
    The sender address for the alert.

.PARAMETER To
    The recpient for the alert to be sent to.

.PARAMETER Subject
    The subject of the alert email.

.EXAMPLE
    .\Get-ServicePrincipalSecrets.ps1 -DaysBeforeExpiration 30
    .\Get-ServicePrincipalSecrets.ps1 -DaysBeforeExpiration 30 -OnlySecrets
    .\Get-ServicePrincipalSecrets.ps1 -DaysBeforeExpiration 30 -OnlyCertificates
    .\Get-ServicePrincipalSecrets.ps1 -DaysBeforeExpiration 0 -OnlySecrets | ForEach-Object {Remove-MgApplicationPassword -ApplicationId $_.ApplicationId -KeyId $_.KeyId} #Removing Secrets
    .\Get-ServicePrincipalSecrets.ps1 -DaysBeforeExpiration 0 -OnlyCertificates | ForEach-Object {Remove-MgApplicationKey -ApplicationId $_.ApplicationId -KeyId $_.KeyId} #Removing Certificates

.NOTES
    Author: Angel Concepcion
    Date: 2024-09-30
    Version: 1.0
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)]
    [int]$DaysBeforeExpiration = 0,
    [Parameter()]
    [switch]$OnlySecrets,
    [Parameter()]
    [switch]$OnlyCertificates,
    [Parameter()]
    [string]$SmtpServer = "some.domain.com",
    [Parameter()]
    [string]$From = "user@email.com",
    [Parameter()]
    [string]$To = "user@email.com",
    [Parameter()]
    [string]$Subject = "Expiring Certificates and Secrets Notification"
)
#
Connect-MgGraph

# Calculate the expiration threshold date
$expirationThreshold = (Get-Date).AddDays($DaysBeforeExpiration)

# Get all app registrations
$appRegistrations = Get-MgApplication -All

# Initialize an array to hold the results
$expiringItems = @()

# Check for expiring certificates and secrets
foreach ($app in $appRegistrations) {

    # Check certificates if OnlyCertificates is specified or neither is specified
    if ($OnlyCertificates -or (-not $OnlySecrets -and -not $OnlyCertificates)) {
        $certificates = $app.KeyCredentials | Where-Object { $_.EndDateTime -lt $expirationThreshold }
        foreach ($cert in $certificates) {
            $expiringItems += [PSCustomObject]@{
                AppName       = $app.DisplayName
                ApplicationId = $app.Id
                ItemType      = "Certificate"
                KeyId         = $cert.KeyId
                EndDate       = $cert.EndDateTime
            }
        }
    }

    # Check secrets if OnlySecrets is specified or neither is specified
    if ($OnlySecrets -or (-not $OnlySecrets -and -not $OnlyCertificates)) {
        $secrets = $app.PasswordCredentials | Where-Object { $_.EndDateTime -lt $expirationThreshold }
        foreach ($secret in $secrets) {
            $expiringItems += [PSCustomObject]@{
                AppName       = $app.DisplayName
                ApplicationId = $app.Id
                ItemType      = "Secret"
                KeyId         = $secret.KeyId
                EndDate       = $secret.EndDateTime
            }
        }
    }
}

# Output the results
$expiringItems


# Function to send email notification
function Send-ExpiryNotification {
  param (
      [array]$Items
  )

  if ($Items.Count -gt 0) {
      # Build the email body
       $htmlBody = @"
<html>
<head>
<style>
    table { border-collapse: collapse; width: 100%; }
    th, td { border: 1px solid #dddddd; padding: 8px; text-align: left; }
    th { background-color: #f2f2f2; }
</style>
</head>
<body>
    <p>Dear Team,</p>
    <p>The following certificates and secrets are expiring within <strong>$DaysBeforeExpiration</strong> days:</p>
    <table>
        <tr>
            <th>App Name</th>
            <th>Application ID</th>
            <th>Item Type</th>
            <th>Key ID</th>
            <th>End Date</th>
        </tr>
"@

        foreach ($item in $Items) {
            $htmlBody += "<tr>"
            $htmlBody += "<td>$($item.AppName)</td>"
            $htmlBody += "<td>$($item.ApplicationId)</td>"
            $htmlBody += "<td>$($item.ItemType)</td>"
            $htmlBody += "<td>$($item.KeyId)</td>"
            $htmlBody += "<td>$($item.EndDate.ToString('yyyy-MM-dd'))</td>"
            $htmlBody += "</tr>"
        }

        $htmlBody += @"
    </table>
    <p>Please take the necessary actions to renew them before they expire.</p>
    <p>Best regards,<br/>Infra Sec Team</p>
</body>
</html>
"@

      # Send the email
      Send-MailMessage -From $from -To $to -Subject $subject -Body $htmlBody -BodyAsHtml `
          -SmtpServer $smtpServer
   }
}
# Call the function to send email if any expiring items are found
Send-ExpiryNotification -Items $expiringItems
