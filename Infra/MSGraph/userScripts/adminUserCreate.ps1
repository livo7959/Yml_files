# This script utilizes Microsoft Graph API to create Azure AD Administrative Users

# Params needed, Name, first name, last name, user prinicpal name

Import-Module Microsoft.Graph.Users

# Connect to Graph with required permissions
Connect-MgGraph -Scopes User.ReadWrite.All,Directory.ReadWrite.All

$params = @{
    accountEnabled = $true
    displayName = "AZ_Stephanie Goguen"
    mailNickname = "sgoguen"
    givenName = "Stephanie"
    surname = "Goguen"
    userPrincipalName = "sgoguenaz@logixhealth.com"
    mail = "sgoguen+pim@logixhealth.com"
    department = "Business Intelligence"
    jobTitle = "Tableau Developer"
    passwordProfile = @{
        ForceChangePasswordNextSignIn = $true
		Password = ""
    }
}

New-MgUser -BodyParameter $params

# Add user to Reader group
# az ad group member add --group AzSub_LH_Sandbox_Dev_001_Readers --member-id
