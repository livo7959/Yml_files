<#

    .SYNOPSIS
        The script runs the deactiation/offbording process for the selected user.

    .DESCRIPTION
 	The script automates key user account management tasks in Active Directory and Azure AD, including disabling accounts, revoking MFA, and setting up litigation holds. 
	It efficiently backs up user group memberships and OneDrive data, sharing the latter with the manager before removal. 
	Additionally, it checks user departments for specific actions, such as removing Call Center accounts from the Five9 Admin Center. 
	However, certain tasks, like disabling Allscripts and LF, require manual intervention. 
	FUTURE UPDATE: Finally, users are moved to a designated deactivated OU and removed from all groups, ensuring a streamlined deactivation process. 

    .PARAMETER Name
            Script Name: Deactiavte_users.ps1

    .OUTPUTS
            Log file path: D:\Logs\Offbording-Logs

    .LINK
            AZDO Login: https://azuredevops.logixhealth.com/LogixHealth

#>

# Log Function
function Log-Action {
    param (
        [string]$message
    )
    Add-Content -Path $logFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $message"
}

# Initialize Variables
$timestamp = Get-Date -Format "yyyy-MM-dd_HH_mm_ss"
$Account = Read-Host "Enter the User Principal Name of the account to block"
$logFile = "D:\Logs\Offbording-Logs\BlockAccount_Log_$Account.txt"
$csvFile = "D:\Logs\Offbording-Logs\BlockAccount_Log_$Account.csv"

# Log the start of the process
Log-Action "Starting the process to block user account: $Account at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

# Function to disable AD account and export user information
function Disable-ADAccountAndExportInfo {
    param (
        [string]$Account
    ) 

    # Check if the user exists
    $user = Get-ADUser -Identity $Account -ErrorAction SilentlyContinue
    if ($user) {
        # Set Litigation Hold before disabling the account
        Set-LitigationHoldAndForward -Account $Account

        # Disable the AD account
        Disable-ADAccount -Identity $Account
        Log-Action "Successfully disabled AD account: $Account at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

        # Get user information
        $userInfo = Get-ADUser -Identity $Account -Properties MemberOf, * | 
                    Select-Object -Property Name, SamAccountName, UserPrincipalName, Enabled, MemberOf

        # Export user information to CSV
        $userInfo | Export-Csv -Path $csvFile -NoTypeInformation
        Log-Action "Exported user information to $csvFile at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

        # Get user groups
        $groups = $user.MemberOf | Get-ADGroup | Select-Object -Property Name

        # Export user groups to the same CSV file
        $groups | Export-Csv -Path $csvFile -Append -NoTypeInformation -Force
        Log-Action "Exported user groups to $csvFile at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    } else {
        Log-Action "User account $Account does not exist at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    }
}

# Function to disable the Azure account and revoke sign-in
function Disable-AzureADAccountAndRevokeSignIn {
    param (
        [string]$Account
    )

    # Get Azure AD user
    $User = Get-MgUser -UserId "$($Account)@logixhealth.com" -ErrorAction SilentlyContinue
    if (!($User)) {
        Write-Host ("Can't find an Azure AD account for {0}" -f $Account)
        Log-Action "Can't find an Azure AD account for $Account at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    } else {
        Write-Host ("Revoking access for account {0}" -f $User.DisplayName)
        Log-Action "Revoking access for account $($User.DisplayName) at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

        # Disable the Azure account
        Update-MgUser -UserId $User.Id -AccountEnabled:$False
        if ($?) {
            Log-Action "Successfully disabled Azure account for $Account at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        } else {
            Log-Action "Failed to disable Azure account for $Account at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        }

        # Revoke signed-in sessions and refresh tokens
        $RevokeStatus = Revoke-MgUserSignInSession -UserId $User.Id
        if ($?) {
            Log-Action "Revoked sign-in sessions for $Account at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        } else {
            Log-Action "Failed to revoke sign-in sessions for $Account at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        }

        # Remove the user's MFA methods
        $MfaMethods = Get-MgUserAuthenticationMethod -UserId $User.Id
        if ($MfaMethods.Count -eq 0) {
            Log-Action "No MFA methods found for $Account at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')."
        } else {
            # Loop through each method and delete it
            foreach ($authMethod in $MfaMethods) {
                DeleteAuthMethod -uid $Account -method $authMethod
            }
            Log-Action "Processed all MFA methods for $Account at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')."
        }
    }
}

# Function to delete authentication methods
function DeleteAuthMethod {
    param (
        [string]$uid,
        [object]$method
    )
    $uid = "$uid@logixhealth.com"
    
    switch ($method.AdditionalProperties['@odata.type']) {
        '#microsoft.graph.microsoftAuthenticatorAuthenticationMethod' {
            Remove-MgUserAuthenticationMicrosoftAuthenticatorMethod -UserId $uid -MicrosoftAuthenticatorAuthenticationMethodId $method.Id
            Log-Action "Deleted Microsoft Authenticator method for $uid at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')."
        }
        '#microsoft.graph.phoneAuthenticationMethod' {
            Remove-MgUserAuthenticationPhoneMethod -UserId $uid -PhoneAuthenticationMethodId $method.Id
            Log-Action "Deleted phone authentication method for $uid at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')."
        }
        '#microsoft.graph.emailAuthenticationMethod' {
            Remove-MgUserAuthenticationEmailMethod -UserId $uid -EmailAuthenticationMethodId $method.Id
            Log-Action "Deleted email authentication method for $uid at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')."
        }
        '#microsoft.graph.fido2AuthenticationMethod' {
            Remove-MgUserAuthenticationFido2Method -UserId $uid -Fido2AuthenticationMethodId $method.Id
            Log-Action "Deleted FIDO2 authentication method for $uid at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')."
        }
        '#microsoft.graph.windowsHelloForBusinessAuthenticationMethod' {
            Remove-MgUserAuthenticationWindowsHelloForBusinessMethod -UserId $uid -WindowsHelloForBusinessAuthenticationMethodId $method.Id
            Log-Action "Deleted Windows Hello for Business method for $uid at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')."
        }
        '#microsoft.graph.softwareOathAuthenticationMethod' {
            Remove-MgUserAuthenticationSoftwareOathMethod -UserId $uid -SoftwareOathAuthenticationMethodId $method.Id
            Log-Action "Deleted software OATH method for $uid at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')."
        }
        '#microsoft.graph.temporaryAccessPassAuthenticationMethod' {
            Remove-MgUserAuthenticationTemporaryAccessPassMethod -UserId $uid -TemporaryAccessPassAuthenticationMethodId $method.Id
            Log-Action "Deleted temporary access pass method for $uid at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')."
        }
        default {
            Log-Action "Unsupported method type: $($method.AdditionalProperties['@odata.type']) for $uid at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')."
        }
    }
}

# Function to set Litigation Hold and setup mail Forwarding
function Set-LitigationHoldAndForward {
    param (
        [string]$Account
    )

    # Enable Litigation Hold
    Set-Mailbox -Identity "$Account@logixhealth.com" -LitigationHoldEnabled $True
    if ($?) {
        Log-Action "Enabled Litigation Hold for $Account at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    }

    # Ask if mail forwarding is required
    $mailForwardingRequired = Read-Host "Does this account require mail forwarding? (yes/no)"
    
    if ($mailForwardingRequired -eq 'yes') {
        # Ask if it's for more than one person
        $moreThanOnePerson = Read-Host "Is this for more than one person? (yes/no)"
        
        if ($moreThanOnePerson -eq 'yes') {
            Write-Host "Please handle this manually, either via a distribution list or a shared mailbox."
            Log-Action "Mail forwarding for more than one person required for $Account at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
            return
        } else {
            # Ask for the forwarding user's email
            $forwardingEmail = Read-Host "Please enter the Manger/user USERNAME ONLY who the mails are being forwarded to User"
            
            # Set the disabled user's address as a proxy in Active Directory
            Set-ADUser -Identity "$forwardingEmail" -Add @{proxyAddresses="smtp:$Account@logixhealth.com"}
            Log-Action "Set $Account as a proxy address for $forwardingEmail at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        }
    }
}

# Function to check the user's department and delete their Five9 account if necessary
function Check-UserDepartmentAndDelete {
    param (
        [string]$Account
    )

    # Get user department
    $user = Get-ADUser -Identity $Account -Properties Department,SamAccountName
    $account = $user.SamAccountName
    if ($user) {
        $department = $user.Department

        if ($department -eq "Call Center" -or $department -eq "Patient Call Center") {
            # Connect to Five9
            Try {
                #$psCred = Get-StoredCredential -Target "F9Script"
                $psCred = get-Credential
                Connect-Five9AdminWebService -Credential $psCred
            } Catch {
                Write-Output "Failed login to Five9 at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')."
                Log-Action "Failed login to Five9 at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
                return
            }

            Start-Sleep -Seconds 15

            # Check and delete the Five9 user account
            $five9User = Get-Five9User $account
            if ($five9User) {
                Remove-Five9User -Username "$account"
                Log-Action "Successfully deleted Five9 user account for $account at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
            } else {
                Log-Action "No Five9 user account found for $Account at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
            }
        } else {
            Log-Action "User $Account is not in the Call Center or Patient Call Center department at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        }
    } else {
        Log-Action "User account $Account does not exist at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    }
}

# Function to remove all Citrix sessions for a user
function Remove-CitrixSessions {
    param (
        [string]$Account
    )

    # Load Citrix modules
    asnp Citrix*

    # Get all active Citrix sessions for the specified user
    $sessions = Get-BrokerSession -FilterValue "$Account"
    if ($sessions) {
        foreach ($session in $sessions) {
            Disconnect-BrokerSession -InputObject $session
            Log-Action "Disconnected Citrix session for $Account at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        }
    } else {
        Log-Action "No active Citrix sessions found for $Account at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    }
}

# Call the functions
Disable-ADAccountAndExportInfo -Account $Account
Disable-AzureADAccountAndRevokeSignIn -Account $Account
Check-UserDepartmentAndDelete -Account $Account
Remove-CitrixSessions -Account $Account

# Log the end of the process
Log-Action "Finished processing user account: $Account at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"


#Post once the abve functiosn ran with no erros -> Its going to move the user to this srusource OU CORP.LOGIXHEALTH.LOCAL/UnManaged Objects/Deactivated Users/Deactivated Employees //? 
#Disable any other accounts that might the user has ?? how to query them? Az, admmin_, dev_ 