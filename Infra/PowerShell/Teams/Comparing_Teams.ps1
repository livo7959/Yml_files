# Connect to Microsoft Teams
#Connect-MicrosoftTeams

#Modules
#Install-Module -Name ImportExcel -RequiredVersion 5.4.2
#Install-Module -Name MicrosoftTeams -Force
#import-module ActiveDirectory

<#~Get Temas Group ID: This command reterives the teams groupID. Its important to note the serach for disaplay name only work if its a unique name. 
For example, the term Remote is part of multiple teams so it reterives all of them so in this sceanior you would have input the GUID Manually as the script will be run bi monthanly#>

#Compares the Teams Channle kept up by HR and the dynamic group -> Remote Communcation (HR) Remote (AD)

# Get members of the Remote Communication   
$RemoteCommunication_Members = Get-TeamUser -GroupId "92d57e62-5261-43a8-8ef6-8465a26e9c71" | Select-Object Name, user, Role
# Filter out the owners (assuming 'Owner' is the role you want to exclude)
$NonOwners_RemoteCommunication = $RemoteCommunication_Members | Where-Object { $_.Role -ne 'Owner' }

# Get members of the Remote                    
$Remote_Members = Get-TeamUser -GroupId "cad78240-e741-4fd3-afc5-46a74ce6f57e" | Select-Object Name, user, Role
# Filter out the owners (assuming 'Owner' is the role you want to exclude)
$NonOwners_Remote = $Remote_Members | Where-Object { $_.Role -ne 'Owner' }

$unique_RemoteCommunication_Members = $NonOwners_RemoteCommunication | Where-Object { $_.user -notin $NonOwners_Remote.user } | Where-Object { $_.Role -ne 'Owner' }
# Display the unique members in each team
#Write-Host "Unique members in Remote Communication:"
#$unique_RemoteCommunication_Members | ForEach-Object { Write-Host $_.user -Separator " " } 

$unique_Remote_Members = $NonOwners_Remote | Where-Object { $_.user -notin $NonOwners_RemoteCommunication.user } | Where-Object { $_.Role -ne 'Owner' }
#Write-Host "Unique members in Remote:"
#$unique_Remote_Members | ForEach-Object { Write-Host $_.user -Separator " " }

# Get members of the Bedford Communication
$BED_Comm_Members = Get-TeamUser -GroupId "255b65d1-fbfc-4a32-9b68-686cf886e7e6" | Select-Object Name, user, Role
$NonOwners_BED_Comm = $BED_Comm_Members | Where-Object { $_.Role -ne 'Owner' }

# Get members of the Bedford                    
$BED_Members = Get-TeamUser -GroupId "3bae027e-8470-4be9-8041-331779d969b5" | Select-Object Name, user, Role
$NonOwners_BED = $BED_Members | Where-Object { $_.Role -ne 'Owner' }

$unique_BED_Comm_Members = $NonOwners_BED_Comm | Where-Object { $_.user -notin $NonOwners_BED.user } | Where-Object { $_.Role -ne 'Owner' }
# Display the unique members in each team
#Write-Host "Unique members in Bedford Communication:"
#$unique_BED_Comm_Members | ForEach-Object { Write-Host $_.user -Separator " " }

$unique_BED_Members = $NonOwners_BED | Where-Object { $_.user -notin $NonOwners_BED_Comm.user } | Where-Object { $_.Role -ne 'Owner' }
#Write-Host "Unique members in Bedford:"
#$unique_BED_Members | ForEach-Object { Write-Host $_.user -Separator " " }

# Add items as needed
$total_users = @();
$total_users += , $unique_RemoteCommunication_Members
$total_users += , $unique_Remote_Members
$total_users += , $unique_BED_Comm_Members
$total_users += , $unique_BED_Members
$total_uname = $total_users.user
#Removes everything after @
$uname_Array = $total_uname | ForEach-Object { $_.Split('@')[0] }

# Create an array to store user information
$ad_office = @()

# Loop through each user in the list
foreach ($user in $uname_Array) {
    # Retrieve the user's information
    $adUser = Get-ADUser -Filter {SamAccountName -eq $user} -Properties DisplayName, Office, Enabled

    # Check if the user is enabled or disabled
    if ($adUser.Enabled) {
        $userObject = [PSCustomObject]@{
            Name = $adUser.DisplayName
            Username = $user
            Office = $adUser.Office
            Status = "Enabled"
        }
    } else {
        $userObject = [PSCustomObject]@{
            Name = $adUser.DisplayName
            Username = $user
            Office = $adUser.Office
            Status = "Disabled"
        }
    }
    # Add the user object to the array
    $ad_office += $userObject
}

#Exporting the CSV with all the content
$unique_RemoteCommunication_Members  | Export-Excel -path 'C:\_IT\Remote_VS_BED_Member_Report.xlsx' -worksheetname "RemoteCommunication" -tablename 'unique_RemoteCommunication_Members' -tablestyle medium6 -freezepane 3  -title "If it is on this list it is not on the Remote Communication TEAMS: $(get-date -format 'MM/dd/yyyy')" -titlesize 13 -autosize
$unique_Remote_Members | Export-Excel -path 'C:\_IT\Remote_VS_BED_Member_Report.xlsx' -worksheetname "Remote" -tablename 'Remote' -tablestyle medium6 -freezepane 3  -title "If it is on this list it is not on the Remote Communication TEAMS: $(get-date -format 'MM/dd/yyyy')" -titlesize 13 -autosize
$unique_BED_Comm_Members | Export-Excel -path 'C:\_IT\Remote_VS_BED_Member_Report.xlsx' -worksheetname "Bedford Communication" -tablename 'Bedford Communication' -tablestyle medium6 -freezepane 3  -title "If it is on this list it is not on the Bedford TEAMS: $(get-date -format 'MM/dd/yyyy')" -titlesize 13 -autosize
$unique_BED_Members | Export-Excel -path 'C:\_IT\Remote_VS_BED_Member_Report.xlsx' -worksheetname "Bedford" -tablename 'Bedford' -tablestyle medium6 -freezepane 3  -title "If it is on this list it is not on the Bedford Communication TEAMS: $(get-date -format 'MM/dd/yyyy')" -titlesize 13 -autosize
$ad_office | Export-Excel -path 'C:\_IT\Remote_VS_BED_Member_Report.xlsx' -worksheetname "Users_Ofice_Attribute" -tablename 'Users_Ofice_Attribute' -tablestyle medium6 -freezepane 3  -title "List Contatins the AD objects with Office property and account: $(get-date -format 'MM/dd/yyyy')" -titlesize 13 -autosize