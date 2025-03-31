
# Get all enabled AD users
$Ad_users = Get-ADUser -Filter {Enabled -eq $true}

# Get all license groups
$total_license_groups = Get-ADGroup -Filter 'Name -like "*"' -SearchBase "OU=License Groups,OU=AzureAD,OU=_IT Administration,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL" | Select-Object -ExpandProperty SamAccountName

# Create an array to store results
$results = @()

# Iterate through each user
foreach ($user in $Ad_users) {
    $user_info = Get-ADUser -Identity $user -Properties Memberof
    $user_membership = $user_info.MemberOf -replace '^cn=([^,]+).+$','$1'
    
    foreach ($group in $user_membership) {
        if ($total_license_groups -contains $group) {
            $result = New-Object PSObject -Property @{
                UserName = $user.Name
                LicenseGroup = $group
            }
            $results += $result
        }
    }
}

#Find Duplicates
$duplicates_names = $results.UserName | Group-Object | Where-Object { $_.Count -gt 1 } | ForEach-Object { $_.Name }
$duplicates_names.Count

#get date
$getdate = (Get-Date -Format 'dd-MM-yyyy')
$results |  Export-Csv -Path "D:\Logs\0365_LicenseAudit\$getdate+o365Licenseuser.csv"



Set-Content -LiteralPath "D:\Logs\0365_LicenseAudit\$getdate+o365Licenseuser.csv" -NoNewLine -Value (@'
"Hiight Duplicate value if the user is part of the following groups they beed both Microsoft_365_F1_WindowsEnt_E5 and Microsoft_Business_Basic_Users. If they have more then 3 groups thats a misconfiguration."
username
'@ + (Get-Content -Raw "D:\Logs\0365_LicenseAudit\$getdate+o365Licenseuser.csv"))