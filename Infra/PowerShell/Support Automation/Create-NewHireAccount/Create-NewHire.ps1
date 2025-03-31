<#AD New Hire Account Setup, this creates a new hire object and provisions the proper base groups and placess the object in the Correct OU for Policy Sync and mangment.

AUTHOR:Jeenil
DATE: 07/05/2024 - STARTED

#>
#List of Requried Modules

#Install-Module sqlserver
#install-module ActiveDirectory

#Log Array
$log_array = @()

#Functions. Get the New hire info fomr the support tech.
function Get-Ticket {
   
    $Ticket_Number = Read-Host "Enter the ticket number for the New Hire"

    $Parent_Incident_ID = $Ticket_Number.Substring(3)
    #Return the IncidentID
    return $Parent_Incident_ID
}

$Ticket_ParentID = Get-Ticket
$Ticket_ParentID

$Ticket_ParentID | out-file -filepath "D:\Scripts\Create-NewHireAccount\incidentID.txt"

#LOG FILE Create a new file based on the Incident ID number 
$log_file = New-Item -Path "D:\Logs\NewHire_Archives\$Ticket_ParentID-log.txt" -ItemType File
$log_file
$log_file_name = "D:\Logs\NewHire_Archives\$Ticket_ParentID-log.txt"

#Add wait time
Start-Sleep -Seconds 3

#Function to run the Scheduled Task and read in the exported file.
Start-ScheduledTask -TaskName "Get-NewHireInfo"

#Add wait time
Start-Sleep -Seconds 20

#Read in the Exported file
$userinfo = import-csv -path "D:\Scripts\Create-NewHireAccount\NewHireInfo.csv"
$userinfo
#Log Schduled Task
if($userinfo){
    $log_array += 'gMSA Scheduled Task ran correctly: TRUE'
}else{
    $log_array += 'gMSA Scheduled Task ran correctly: TRUE" "gMSA Scheduled Task ran correctly: FALSE'
}

#Function to Map Seat Number to the UPDATED Seat Number Created by Branding
function Get-NewSeatNumberConversion {
    param (
        [string]$SeatNumber
    )

    # Import the Conversion mapping CSV
    $seat_mapping = Import-Csv -Path "D:\Scripts\Create-NewHireAccount\Src\Seat_Conversion.csv"
    
    # Find the row where IT_Desk_Number matches the given seat_number
    $matching_row = $seat_mapping | Where-Object { $_.IT_Desk_Number -eq $userinfo.value[7] }

    if ($matching_row) {
        # Get the value from the "Desk_Location" column
        $new_seat_number = $matching_row.Desk_Location
        Write-Output "New seat number for AD Oject is: $new_seat_number"
    } else {
        Write-Output "No mapping found for seat number $new_seat_number."
    }
}

#Pass in the Ticket SeatNumber
$new_seat_number = Get-NewSeatNumberConversion -SeatNumber $userinfo.value[7]
$new_seat_number
#Log Schduled Task
#Log for Seat Number
if($new_seat_number){
    $log_array += "new Seat Number is: $new_seat_number"
}else{
    $log_array += "Could not get the seat number. "
}

#Function To get the User after the Template Name/CN of to mirror based on the title and department
function Get-TemplateInfo {
    param (
        [string]$Department,
        [string]$title
    )
        $Department = $userinfo.value[11]
        $Dept = $Department.Replace("&", "and")
        
    #Replace any & with AND
    # Read in the Template File
        $Template_XML_File = "D:\Scripts\Create-NewHireAccount\Src\Template_Strucutre.xml"
        $templates =  [xml](Get-Content -Path $Template_XML_File)

    # Based on the Department Passed in, get the Proper Template
        $matchingDepartment = $templates.SelectNodes("//Department[@name='$Dept']")
        $Department_name = $matchingDepartment.name;

        if ($Department_name) {

            switch ($Department_name) {
                "Analytics and Innovation" {
                    if($userinfo.value[10] -match "Senior Product Manager" -or $userinfo.value[10] -match "Director" -or $userinfo.value[10] -match "Director, Data Science" -or $userinfo.value[10] -match "Project Manager" -or $userinfo.value[10] -match "Executive Director" -or $userinfo.value[10] -match "Senior Manager"){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Audit and Contracting" {
                    if($userinfo.value[10] -match "Contract Manager" -or $userinfo.value[10] -match "Junior Account Manager" -or $userinfo.value[10] -match "Associate Director"){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Billing Applications" {
                    if($userinfo.value[10] -match "Manager" -or $userinfo.value[10] -match "Director"){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Billing Operations" {
                    if($userinfo.value[10] -match "Senior Director" -or $userinfo.value[10] -match "Junior Account Manager" -or $userinfo.value[10] -match "Associate Director" -or $userinfo.value[10] -match "Account Manager" -or $userinfo.value[10] -match "Executive Director" -or $userinfo.value[10] -match "Director" -or $userinfo.value[10] -match "Manager"){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Brand Identity" {
                    if($userinfo.value[10] -match "Manager"){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Cash Management" {
                    if($userinfo.value[10] -match "Manager" -or $userinfo.value[10] -match "Director" -or $userinfo.value[10] -match "Associate Director" -or $userinfo.value[10] -match "Assistant Manager"){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Client Services" {
                    if($userinfo.value[10] -match "Manager" -or $userinfo.value[10] -match "Director" -or $userinfo.value[10] -match "Associate Director" -or $userinfo.value[10] -match "Senior Manager" -or $userinfo.value[10] -match "Practice Manager" -or $userinfo.value[10] -match "Assistant Manager" -or $userinfo.value[10] -match "Vice President" -or $userinfo.value[10] -match "Coordinator" -or $userinfo.value[10] -match "Senior Coordinator" -or $userinfo.value[10] -match "*"){
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Coding" {
                    if($userinfo.value[10] -match "Manager" -or $userinfo.value[10] -match "Senior Operations Manager" -or $userinfo.value[10] -match "Associate Director"){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Coding Applications" {
                    if($userinfo.value[10] -match "Assistant Manager" -or $userinfo.value[10] -match "Associate Director" -or $userinfo.value[10] -match "Senior Director" -or $userinfo.value[10] -match "Manager"){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Coding Quality" {
                    if($userinfo.value[10] -match "Senior Manager" -or $userinfo.value[10] -match "Assistant Manager" -or $userinfo.value[10] -match "Resource Manager" -or $userinfo.value[10] -match "Senior Operations Manager" -or $userinfo.value[10] -match "Manager" -or $userinfo.value[10] -match "Director" ){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "ED Billing" {
                    if($userinfo.value[10] -match "Senior Manager" -or $userinfo.value[10] -match "Assistant Manager" -or $userinfo.value[10] -match "Associate Director"){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "EDI" {
                    if($userinfo.value[10] -match "Director" -or $userinfo.value[10] -match "Junior Account Manager" -or $userinfo.value[10] -match "Associate Director" -or $userinfo.value[10] -match "Manager"){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Facility Charge Entry" {
                    if($userinfo.value[10] -match "Senior Manager"){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Finance" {
                    if($userinfo.value[10] -match "Associate Director" -or $userinfo.value[10] -match "Executive Director" -or $userinfo.value[10] -match "Accounting Services Manager" -or $userinfo.value[10] -match "Director" -or $userinfo.value[10] -match "Vice President"){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Human Resources" {
                    if($userinfo.value[10] -match "Senior Director" -or $userinfo.value[10] -match "Director" -or $userinfo.value[10] -match "Associate Director"){
                        $Mirror_template = $matchingDepartment.Base_Human_Resources_Director
                    }if($userinfo.value[10] -match "Manager"){
                        $Mirror_template = $matchingDepartment.Base_Human_Resources_Mgmt
                    }if($userinfo.value[10] -match "Recruiting Coordinator"){
                        $Mirror_template = $matchingDepartment.Base_Human_Resources_Coordinator
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }                   
                }
                "Infrastructure and Security" {
                    # Action for IT department
                    if($userinfo.value[10] -match "Senior Systems Administrator" -or $userinfo.value[10] -match  "Cloud DevOps Engineer" -or $userinfo.value[10] -match "Senior Engineer" -or $userinfo.value[10] -match "Senior Release Engineer" -or $userinfo.value[10] -match "Lead Systems Administrator" -or $userinfo.value[10] -match "System Administrator"){
                        $Mirror_template = $matchingDepartment.Base_Infra_Systems_Administrator
                    }
                    if($userinfo.value[10] -match "Senior Vice President of Infrastructure"){
                        $Mirror_template = $matchingDepartment.Base_Infra_Director
                    }
                    if($userinfo.value[10] -match "Engineer 2, Security" -or $userinfo.value[10] -match "Security Administrator"){
                        $Mirror_template = $matchingDepartment.Base_SecurityEng
                    }
                    if($userinfo.value[10] -match "Senior Systems Support Manager" -or $userinfo.value[10] -match "Security & Risk Manager" -or $userinfo.value[10] -match "Cloud Infrastructure Manager"){
                        $Mirror_template = $matchingDepartment.Base_Infra_Sup_Manager
                        $userinfo.value[10]
                    }
                    else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Integration Services" {
                    if($userinfo.value[10] -match "Associate Director" -or $userinfo.value[10] -match "Associate Director" -or $userinfo.value[10] -match "Senior Director"){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Medical Records Administration" {
                    if($userinfo.value[10] -match "Senior Director" -or $userinfo.value[10] -match "Manager" -or $userinfo.value[10] -match "Associate Director" -or $userinfo.value[10] -match "Director" -or $userinfo.value[10] -match "Assistant Manager"){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Patient Call Center" {
                    if($userinfo.value[10] -match "Quality & Training Manager" -or $userinfo.value[10] -match "Director" -or $userinfo.value[10] -match "Senior Manager"){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Professional Charge Entry" {
                    if($userinfo.value[10] -match "Assistant Manager"){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Provider Education" {
                    if($userinfo.value[10] -match "Manager" -or $userinfo.value[10] -match "Associate Director"){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Provider Enrollment" {
                    if($userinfo.value[10] -match "Contract Manager" -or $userinfo.value[10] -match "Senior Manager" -or $userinfo.value[10] -match "Assistant Manager" -or $userinfo.value[10] -match "Project Manager" -or $userinfo.value[10] -match "Associate Director"){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Reimbursement" {
                    if($userinfo.value[10] -match "Junior Account Manager" -or $userinfo.value[10] -match "Account Manager" -or $userinfo.value[10] -match "Senior Account Manager" -or $userinfo.value[10] -match "Junior Account Manager" -or $userinfo.value[10] -match "Associate Director" ){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Software Development" {
                    if($userinfo.value[10] -match "Manager" -or $userinfo.value[10] -match "Senior Director" -or $userinfo.value[10] -match "Director" -or $userinfo.value[10] -match "Business Analysis Manager" -or $userinfo.value[10] -match "Senior Director of Product and Business Analysis" -or $userinfo.value[10] -match "QA Manager" -or $userinfo.value[10] -match "Project Manager" -or $userinfo.value[10] -match "Director of Project Management"){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }
                    if($userinfo.value[10] -match '*QA*'){
                        $Mirror_template = $matchingDepartment.Base_Soft_Dev_QA
                    }
                    if($userinfo.value[10] -match '*BA*'){
                        $Mirror_template = $matchingDepartment.Base_Soft_Dev_BA
                    }
                    else{
                        $Mirror_template = $matchingDepartment.Base_Soft_Dev_Base
                    }
                }
                "Specialty Billing" {
                    if($userinfo.value[10] -match "Senior Manager" -or $userinfo.value[10] -match "Senior Director" -or $userinfo.value[10] -match "Junior Account Manager" -or $userinfo.value[10] -match "Account Manager" -or $userinfo.value[10] -match "Operations Manager"){
                        $Mirror_template = $matchingDepartment.Mgmt_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Technology Lab" {
                    if($userinfo.value[10] -match "*"){
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }else{
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                default {
                    # Action for any other department not listed above
                    Write-Host "Unknown department: $Department"
                    # Add your specific code here
                }
            }
        return $Mirror_template
    } else {
        return "Department '$Department' not found in the XML."
    }
}

#Get the Template
$Mirror_template = Get-TemplateInfo -Department $userinfo.value[11] -title $userinfo.value[10]
Write-Output("Tempalte to Mirror: $Mirror_template")
$Mirror_template = $Mirror_template.Replace('"', '')
#Log for Template
if($Mirror_template ){
    $log_array += "Mirror Template is: $Mirror_template"
}else{
    $log_array += 'Could not find a tempalte to mirror.'
}


#Get the Destination OU and Move the User locaiton. Have to do this for te whole destination String it it exisit .Replace("&", "and")
# if the user is MGMT then also set the destination to "OU=Patient Call Center Supervisor Users,OU=Patient Call Center Users,OU=Department Users,OU=Internal,OU=Bedford,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
function Get-DestinationOU {
    param (
        [string]$Department
    )
    $Department = $userinfo.value[11]
    $Dept = $Department.Replace("&", "and")
    
#Replace any & with AND
# Read in the Template File
    $Template_XML_File = "D:\Scripts\Create-NewHireAccount\Src\Template_Strucutre.xml"
    $templates =  [xml](Get-Content -Path $Template_XML_File)

# Based on the Department Passed in, get the Proper Template
    $matchingDepartment = $templates.SelectNodes("//Department[@name='$Dept']")
    $Department_name = $matchingDepartment.name;

    if ($Department_name) {

        switch ($Department_name) {
            "Analytics and Innovation" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Audit and Contracting" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Billing Applications" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Billing Operations" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Brand Identity" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Cash Management" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Client Services" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Coding" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Coding Applications" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Coding Quality" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "ED Billing" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "EDI" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Facility Charge Entry" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Finance" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Human Resources" {
                $destination_path = $matchingDepartment.AD_Destination_OU 
            }
            "Infrastructure and Security" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Integration Services" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Medical Records Administration" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Patient Call Center" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Professional Charge Entry" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Provider Education" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Provider Enrollment" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Reimbursement" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Software Development" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Specialty Billing" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Technology Lab" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            default {
                # Action for any other department not listed above
                Write-Host "Destination department OU not found."
                # Add your specific code here
            }
        }
    return $destination_path
    } else {
        return "Department '$Department' not found in the XML."
    }

    #Department logs
    if($destination_path ){
        $log_array += "Destination Path is: $destination_path"
    }else{
        $log_array += "Could not find a Destination Path: Department '$Department' not found in the XML."
    }
}

#Get the path and Pass it into the New Hire function
$destination_path = Get-DestinationOU -Department $info.department
Write-Output("Destination User OU: $destination_path")
$destination_path

Start-Sleep -Seconds 3

#Create New Hire, pass in the template and the rest of the info from the Ticket and the Avaliable UserName Function
function Create_NewHire {
    param (
        [string]$Title,
        [string]$Department,
        [string]$FirstName,
        [string]$LastName,
        [string]$Manager,
        [string]$available_username,
        [string]$new_seat_number,
        [string]$Mirror_template,
        [string]$destination_path,
        [string]$WorkEnvironment,
        [string]$PersonalEmail
    )

    # Correct variable names
    $Title =  $userinfo.value[10]
    $Department =  $userinfo.value[11]
    $FirstName =  $userinfo.value[5]
    $LastName =  $userinfo.value[6]
    $personalEmail = $userinfo.value[9]
   
    # Define the new user details
    $newUser = @{
        AccountPassword         = Read-Host "Enter the account password" -AsSecureString
        Description             = $userinfo.value[10]
        DisplayName             = $userinfo.value[5] + ' ' + $userinfo.value[6]
        EmailAddress            = $userinfo.value[1] + "@logixhealth.com"
        GivenName               = $userinfo.value[5]
        Name                    = $userinfo.value[5] + ' ' + $userinfo.value[6]
        Department              = $userinfo.value[11]
        Surname                 = $userinfo.value[6]
        SamAccountName          = $userinfo.value[1]
        Title                   = $userinfo.value[10]
        UserPrincipalName       = $userinfo.value[1] + "@logixhealth.com"
        Enabled                 = $false
    }
    $newUser

# Create the new user
New-ADUser @newUser

Start-Sleep -Seconds 5

# Define the template user (assume we get the template user by a specific identifier, e.g., SAMAccountName)
$templateUser = get-aduser -identity $Mirror_template -Properties * | Select Company, PrimaryGroupID, MemberOf, HomePage, wWWHomePage, Office ,City, Country, State, StreetAddress, PostalCode

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

        # Add the new user to the same groups as the template user
        $templateUser.MemberOf | ForEach-Object {
            Add-ADGroupMember -Identity $_ -Members $newUser.SamAccountName
        }
}
Start-Sleep -Seconds 3
        $Manager_name =  $userinfo.value[4] 
        #Setting the Manager
        #Bsed on the Display Name get the users SameAccountName
        $managerUsername = Get-ADUser -Filter "DisplayName -like '$Manager_name*'" | Select SamAccountName
        $managerUsername
        
Start-Sleep -Seconds 3
        #Set the new hires Manager
        Set-ADUser -Identity $userinfo.value[1] -Manager $managerUsername
        #Log for Manager
        if($managerUsername ){
            $log_array += "User mangager Set to: $managerUsername"
        }else{
           $log_array += 'Could not find a manger with that name in AD.'
        }

Start-Sleep -Seconds 3
        #Get New users Guid
        $userIdentity = Get-aduser $userinfo.value[1] -Properties * 
        $userIdentity.ObjectGUID
 Start-Sleep -Seconds 3       
        #Get the OUs Guid
        $destination_path = $destination_path.Replace('"', '')
        $Ou_guid = Get-ADOrganizationalUnit $destination_path | select ObjectGUID
        $Ou_guid.ObjectGUID
Start-Sleep -Seconds 3
        #Set the User Extra Attributes i.e. Office Filed
        if ($userinfo.value[3] -match "Onsite*" -or $userinfo.value[3] -match "Hybrid*" ) {
            Set-ADUser -Identity $userIdentity.SamAccountName -Add @{extensionattribute8="Corporate"}
        }else{
            Set-ADUser -Identity $userIdentity.SamAccountName -Add @{extensionattribute7="Remote"}
        }
Start-Sleep -Seconds 3
        #Move the user to the proper OU
        Move-ADObject -Identity $userIdentity.ObjectGUID -TargetPath $Ou_guid.ObjectGUID

        #Set Seat  
        $new_seat_number
        Set-ADUser -Identity $userIdentity.SamAccountName -Add @{extensionattribute8="$new_seat_number"}
        #Log for Seat Number
        if($managerUsername ){
            $log_array += 'User mangager Set to: $managerUsername'
        }else{
           $log_array += 'Could not find a manger with that name in AD.'
        }

        #Set AD Users Field for Personal Email Extension Attribute12
        $PersonalEmail
        Set-ADUser -Identity $userIdentity.SamAccountName -Add @{extensionattribute11="$PersonalEmail"}
        #Log for Personal Email
        if($PersonalEmail){
             $log_array += "Extenstion11 Attribute set: $PersonalEmail"
        }else{
             $log_array += "Could not find users PersonalEmail."
        }

        #Set AD Users Field for Phone Number Extension Attribute11

        Write-Host "New user created and properties copied successfully."
        
    Add-Content -Path $log_file_name -Value $log_array
}

Start-Sleep -Seconds 3
$NewHire = Create_NewHire -Title $userinfo.value[10] -Department $userinfo.value[11] -FirstName $userinfo.value[5] -LastName $userinfo.value[6] -Manager $userinfo.value[4] -available_username $userinfo.value[11] -new_seat_number $new_seat_number -Mirror_template $Mirror_template -destination_path $destination_path -office $userinfo.value[4] -PersonalEmail $userinfo.value[9]
$NewHire

$nrwhireinfo = Get-aduser $userinfo.value[1]

$log_array += $nrwhireinfo

#Export Logs
Add-Content -Path $log_file_name -Value $log_array

#Function to move the log file/new hire info file to an archive folder once the script finishes and the account is created.
$Archive_path            = "D:\Logs\NewHire_Archives\"
$newhireinfo_file_path   = "D:\Scripts\Create-NewHireAccount\NewHireInfo.csv"
$NewhireIncidentID_path  = "D:\Scripts\Create-NewHireAccount\incidentID.txt"

#Rename the files and move them to the Archive Path based on the users name and date.
$currentDate = Get-Date -Format yyyy-MM-dd
$username = $userinfo.value[1]

#Move files:

Move-Item $newhireinfo_file_path -destination $Archive_path
Move-Item $NewhireIncidentID_path -destination $Archive_path

$RenameCsv = "D:\Logs\NewHire_Archives\$currentDate-NewHireInfo-$username.csv"
$RenameIncidentId = "D:\Logs\NewHire_Archives\$currentDate-incidentID-$username.txt"

Rename-Item -Path "D:\Logs\NewHire_Archives\incidentID.txt" -NewName $RenameIncidentId
Rename-Item -Path "D:\Logs\NewHire_Archives\NewHireInfo.csv" -NewName $RenameCsv












