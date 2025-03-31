#Connect up to MgGraph using an Enterprise application and a Certificate to authenticate from the server
Connect-MgGraph -ClientId "ClientId" -CertificateThumbprint "-CertificateThumbprint-ID" -TenantId "TenantId"

<# Guest User invite function creates the user first but does not send out the invites, the reason
   is so the users object can be updated on Azure and also to add the user to an Access Package if one provided before sending out the invites.
#>
function Setup-AzureADGuestUsers {
    param (
        [string]$csvFilePath,
        [string]$accessPackageName
    )

    $AzureADUsers = Import-Csv $csvFilePath
    $AzureADUsers

    # Adds the Guest user to AzureAD and DOES NOT send the original invite before setting the proper properties and then sending out the invites.
    foreach ($user in $AzureADUsers) {
        New-MgInvitation -InvitedUserDisplayName $user.DisplayName `
            -InvitedUserEmailAddress $user.Email `
            -InviteRedirectUrl "https://myapplications.microsoft.com" `
            -SendInvitationMessage:$false
    }

    # This step updates the user property in Azure and updates the attributes based on the original spreadsheet selected.
    $i = 0
    $TotalRows = $AzureADUsers.Count

    # Array to add update status
    $UpdateStatusResult = @()

    # Iterate and set user details one by one
    ForEach ($UserInfo in $AzureADUsers) {
        $UserId = $UserInfo.UserPrincipalName

        # Convert CSV user info (PSObject) to hashtable
        $NewUserData = @{
            Name        = $UserInfo.Name
            DisplayName = $UserInfo.DisplayName
            CompanyName = $UserInfo.CompanyName
            Mail        = $UserInfo.Email
        }

        $i++
        Write-Progress -Activity "Processing $UserId " -Status "$i out of $TotalRows completed"

        # Wait for a few seconds before looking up the user
        Start-Sleep -Seconds 5

        Try {
            # Get current Azure AD user object using Microsoft Graph
            $UserObj = Get-MgUser -UserId $UserId

            # Convert current Azure AD user object to hashtable
            $ExistingUserData = @{
                Name        = $UserObj.Name
                DisplayName = $UserObj.DisplayName
                CompanyName = $UserObj.CompanyName
                Mail        = $UserObj.Mail
            }

            $AttributesToUpdate = @{}

            # The CSV header names should have the same member property name supported in the Get-MgUser cmdlet.
            $CSVHeaders = @("Name", "DisplayName", "CompanyName", "Mail")

            ForEach ($property in $CSVHeaders) {
                # Check the CSV field has value and compare the value with existing user property value.
                if ($NewUserData[$property] -ne $null -and ($NewUserData[$property] -ne $ExistingUserData[$property])) {
                    $AttributesToUpdate[$property] = $NewUserData[$property]
                }
            }
            if ($AttributesToUpdate.Count -gt 0) {
                # Set required user attributes.
                # Need to prefix the variable AttributesToUpdate with @ symbol instead of $ to pass hashtable as parameters (ex: @AttributesToUpdate).
                Update-MgUser -UserId $UserId @AttributesToUpdate
                $UpdateStatus = "Success - Updated attributes : " + ($AttributesToUpdate.Keys -join ',')
            }
            else {
                $UpdateStatus = "No changes required"
            }
        }
        catch {
            $UpdateStatus = "Failed: $_"
        }

        # Add user update status
        $UpdateStatusResult += [PSCustomObject]@{
            User   = $UserId
            Status = $UpdateStatus
        }
    }

    # Display the user update status result
    $UpdateStatusResult | Select User, Status

    # Add access package assignment after user creation if access package name is provided
    if ($accessPackageName) {
        $accessPackage = Get-MgEntitlementManagementAccessPackage -Filter "displayName eq '$accessPackageName'" -ExpandProperty "assignmentpolicies"
        if ($null -eq $accessPackage) {
            throw "No access package found with the name '$accessPackageName'"
        }
        if ($accessPackage.AssignmentPolicies.Count -eq 0) {
            throw "No assignment policies found for the access package '$accessPackageName'."
        }
        $policy = $accessPackage.AssignmentPolicies[0]
        $params = @{
            requestType = "adminAdd"
            assignment  = @{
                targetId           = $UserObj.Id
                assignmentPolicyId = $policy.Id
                accessPackageId    = $accessPackage.Id
            }
        }
        New-MgEntitlementManagementAssignmentRequest -BodyParameter $params
        Write-Output "User $($UserObj.DisplayName) has been added to the access package $accessPackageName."
    }

    # Send out the invites
    Send-Invites -AzureADUsers $AzureADUsers
}

function Send-Invites {
    param (
        [array]$AzureADUsers
    )

    $customizedMessageBody = "You have been invited to join the LogixHealth network to collaborate and/or access our shared resources.

LogixHealth uses Microsoft Entra ID to enhance the security of our network with a login process that includes multifactor authentication (MFA) with biometric factors instead of a password. To complete this setup, you will also need an authenticator app on your mobile phone, such as Microsoft Authenticator, available for free from the Google Play or Apple App Store. This MFA application enhances security by enabling quick and easy biometric identity confirmation on a mobile device.

To get started, please click the ‘Accept invitation’ link below to join our network and set-up the Microsoft multifactor authentication (MFA) process. ‘More detailed instructions can be found here: https://www.logixhealth.com/Files/LogixHealth_How_to_Access_Shared_Documents.pdf'

For current users of Microsoft Office 365, copy and paste the ‘Accept invitation’ link to a Chrome Incognito mode or Edge InPrivate mode browser window to ensure access to the registration process.

If you have any questions regarding this set up, please contact LogixHealth Technical Support at 781.280.1600.

Thank you
"
    $logFile = "C:\_IT\UserInvite_Email.csv"

    foreach ($user in $AzureADUsers) {
        $invitation = New-MgInvitation -InvitedUserEmailAddress $user.Email -InviteRedirectUrl "https://myapplications.microsoft.com" -InvitedUserMessageInfo @{
            "MessageLanguage"       = "en-US";
            "CustomizedMessageBody" = $customizedMessageBody;
        } -InvitedUserType Guest -SendInvitationMessage:$true

        $x = Get-Date

        $logEntry = [PSCustomObject][ordered]@{
            'Timestamp'        = $x
            'Email'            = $user.Email
            'InvitationStatus' = $invitation.Status
        }

        if (-not (Test-Path $logFile)) {
            $header = "Timestamp", "Email", "InvitationStatus"
            $header -join "," | Out-File -FilePath $logFile -Encoding utf8
        }

        $logEntry | ConvertTo-Csv -NoTypeInformation -Delimiter "," | Select-Object -Skip 1 | Out-File -Append -FilePath $logFile -Encoding utf8
    }

    Write-Host "Invitation logs exported to $logFile"
}

# Ask the user to provide the path to the csv file and import it an object called $AzureADUsers
$csvFilePath = Read-Host "Enter the path to your CSV file (e.g., C:\path\to\your\file.csv)"
$accessPackageName = Read-Host "Enter the name of the access package (leave blank if not applicable)"
Setup-AzureADGuestUsers -csvFilePath "$csvFilePath" -accessPackageName $accessPackageName