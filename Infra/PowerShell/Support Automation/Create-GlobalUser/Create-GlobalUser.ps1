#Author: Jeenil Patel
#Date: 8/21/2024

# Start logging
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logPath = "\\BEDPAUTOSPRT001\LHI_Support\Logs\Globaluser_$timestamp.txt"
Start-Transcript -Path $logPath

#INITILIZE THE VARIABLES

# Start logging
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logPath = "\\BEDPAUTOSPRT001\LHI_Support\Logs\NewGlobalHireScriptLog_$timestamp.txt"
Start-Transcript -Path $logPath

#Read in the file for the user Account creation.
$file_path = Read-Host "Enter the New Hire Tempalte path for global user. MAKE SURE there are no space in the Path and any quotes:"
$NewHires = Import-Csv -Path $file_path

#Function To get the User after the Template Name/CN of to mirror based on the title and department
function Get-TemplateInfo {
    param (
        [string]$Department,
        [string]$title
    )

    #Templats Mapping
    $Global_Auditors                     = "CN=Global Auditor Template,OU=Template Accounts,OU=Bedford,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
    $Global_Billers                      = "CN=Global Biller Template,OU=Template Accounts,OU=Bedford,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
    $Global_Coders                       = "CN=Global Coder Template,OU=Template Accounts,OU=Bedford,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
    $Global_Patient_Call_Center_Users    = "CN=Global Call Center Template,OU=Template Accounts,OU=Bedford,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
     
    # Based on the Department Passed in, get the Proper Template
        $Department_name = $Department;

        if ($Department_name) {

            switch ($Department_name) {
               
                "Coding Operations" {
                    if($title -match "Auditor" -or $title -match "Global Auditor" -or $title -match "Global Internal Auditor" -or $title -match "Internal Auditor" -or $title -match "Production Lead"){
                        $Mirror_template = $Global_Auditors
                    }
                    if($title -match "Assistant Manager" -or $title -match "Coder" -or $title -match "Global Coder" -or $title -match "Global Production Lead") {
                        $Mirror_template = $Global_Coders
                    }
                }
                "Billing Operations" {
                    if($title -match "Biller" -or $title -match "Global Biller") {
                        $Mirror_template = $Global_Billers
                    }
                }
                "Patient Call Center" {
                    $Mirror_template = $Global_Patient_Call_Center_Users
                }

                default {
                    # Action for any other department not listed above
                    Write-Host "Unknown department: $Department"
                    # Add your specific code here
                }
            }
        return $Mirror_template
    } else {
        return "Department '$Department' not found."
    }
}

function Get-DestinationOU {
    param (
        [string]$Department
    )
    $Department_name = $NewHire.department;
    $Dept = $Department.Replace("&", "and")
    
    
    #Destination OU Path for each unique global user Description
    $Global_Auditors_OU                     = "OU=Global Auditors,OU=Global,OU=Outsourcing Partners,OU=Bedford,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
    $Global_Billers_OU                      = "OU=Global Billers,OU=Global,OU=Outsourcing Partners,OU=Bedford,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
    $Global_Coders_OU                       = "OU=Global Coders,OU=Global,OU=Outsourcing Partners,OU=Bedford,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
    $Global_Patient_Call_Center_Users_OU    = "OU=Global Patient Call Center Users,OU=Global,OU=Outsourcing Partners,OU=Bedford,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"

        if ($Department_name) {

            switch ($Department_name) {
               
                "Coding Operations" {
                    if($Newhire.title -match "Auditor" -or $newhire.title -match "Global Auditor" -or $newhire.title -match "Global Internal Auditor" -or $newhire.title -match "Internal Auditor" -or $newhire.title -match "Production Lead"){
                        $destination_path = $Global_Auditors_OU
                    }
                    if($Newhire.title -match "Assistant Manager" -or $newhire.title -match "Coder" -or $newhire.title -match "Global Coder" -or $newhire.title -match "Global Production Lead") {
                        $destination_path = $Global_Coders_OU
                    }
                }
                "Billing Operations" {
                    if($Newhire.title -match "Biller" -or $newhire.title -match "Global Biller") {
                        $destination_path = $Global_Billers_OU
                    }
                }
                "Patient Call Center" {
                    $destination_path = $Global_Patient_Call_Center_Users_OU
                }
                default {
                    # Action for any other department not listed above
                    Write-Host "Unknown department: $Department"
                    # Add your specific code here
                }
            } return $destination_path
    } else {
        return "Department '$Department' not found in the XML."
    }

}

function Create_NewHire {
    param (
        [string]$Title,
        [string]$Department,
        [string]$FirstName,
        [string]$LastName,
        [string]$SAMAccountName,
        [string]$Mirror_template,
        [string]$destination_path
    )
   
       $user_name =  $NewHires.GBL_NUM_Username
       $Disaplay_name = $NewHires.DisplayName
       $Fname = $NewHires.FirstName
       $Lname =  $NewHires.LastName
       $email =  $NewHires.EmailAddress
       $Newhire_title =  $NewHires.Title
       $dept =  $NewHires.Department
       $desc =  $NewHires.Description

    # Define the new user details
    $newUser = @{
        AccountPassword         = Read-Host "Enter the account password" -AsSecureString
        Description             = $Newhire.description
        DisplayName             = $Newhire.FirstName + ' ' + $Newhire.LastName
        EmailAddress            = $Newhire.EmailAddress
        GivenName               = $Newhire.FirstName
        Name                    = $Newhire.FirstName + ' ' + $Newhire.LastName
        Department              = $Newhire.department
        Surname                 = $Newhire.LastName
        SamAccountName          = $NewHire.GBL_NUM_Username
        Title                   = $Newhire.Title
        UserPrincipalName       = $Newhire.EmailAddress
        Enabled                 = $false
    }
    $newUser

        # Create the new user
        New-ADUser @newUser

        Start-Sleep -Seconds 5

        # Define the template user (assume we get the template user by a specific identifier, e.g., SAMAccountName)
        $templateUser = get-aduser -identity $Mirror_template -Properties * | Select Company, PrimaryGroupID, MemberOf, HomePage, wWWHomePage, Office ,City, Country, State, StreetAddress, PostalCode,telephoneNumber

        $templateUser

            # Copy the selected properties from the template user to the new user
            if ($templateUser) {
                Set-ADUser -Identity $newUser.SamAccountName -Company $templateUser.Company
                Set-ADUser -Identity $newUser.SamAccountName -Office $templateUser.office
                Set-ADUser -Identity $newUser.SamAccountName -HomePage $templateUser.HomePage
                Set-ADUser -Identity $newUser.SamAccountName -City $templateUser.City
                Set-ADUser -Identity $newUser.SamAccountName -Country $templateUser.Country
                Set-ADUser -Identity $newUser.SamAccountName -State $templateUser.State
                Set-ADUser -Identity $newUser.SamAccountName -StreetAddress $templateUser.StreetAddress
                Set-ADUser -Identity $newUser.SamAccountName -PostalCode $templateUser.PostalCode
                Set-ADUser -Identity $newUser.SamAccountName -PostalCode $templateUser.telephoneNumber

                # Add the new user to the same groups as the template user
                $templateUser.MemberOf | ForEach-Object {
                    Add-ADGroupMember -Identity $_ -Members $newUser.SamAccountName
                }
        }
        Start-Sleep -Seconds 3
            
                $userIdentity = Get-aduser $newUser.SamAccountName -Properties * 
                $userIdentity.ObjectGUID
        Start-Sleep -Seconds 3       
                #Get the OUs Guid
                $destination_path = $destination_path.Replace('"', '')
                $Ou_guid = Get-ADOrganizationalUnit $destination_path | select ObjectGUID
                $Ou_guid.ObjectGUID

        Start-Sleep -Seconds 3
                #Move the user to the proper OU
                Move-ADObject -Identity $userIdentity.ObjectGUID -TargetPath $Ou_guid.ObjectGUID
                Write-Host "New user created and properties copied successfully."

}

foreach ($Newhire in $NewHires) {
    # Get the Template
    $Mirror_template = Get-TemplateInfo -Department $Newhire.department -Title $Newhire.Title
    Write-Output ("The users department is: $Newhire.department")
    Write-Output ("Template to Mirror: $Mirror_template")
    $Mirror_template = $Mirror_template.Replace('"', '')

     # Get the path and pass it into the New Hire function
    $destination_path = Get-DestinationOU -Department $Newhire.department
    Write-Output ("The users department is: $Newhire.department")
    Write-Output ("Destination User OU: $destination_path")

     # Start-Sleep -Seconds 3
    $NewHire = Create_NewHire -Title $Newhire.Title -Department $Newhire.department -FirstName $Newhire.FirstName -LastName $Newhire.LastName -SAMAccountName $Newhire.GBL_NUM_Username -Mirror_template $Mirror_template -destination_path $destination_path
    Write-Output ($NewHire)

}

# Stop logging
Stop-Transcript