#Author: Jeenil Patel
#Date: 8/21/2024

# Start logging
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logPath = "\\BEDPAUTOSPRT001\LHI_Support\Logs\NewHireScriptLog_$timestamp.txt"
Start-Transcript -Path $logPath

#Function To get the User after the Template Name/CN of to mirror based on the title and department
function Get-TemplateInfo {
    param (
        [string]$Department,
        [string]$title
    )
        $Department = $Newhire.Department
        $Dept = $Department.Replace("&", "and")
        
    #Replace any & with AND
    # Read in the Template File
        $Template_XML_File = "\\Bedpautosprt001\d$\LHI_Support\Scripts\Creat-NewHire\src\Template_Strucutre_Coimbatore.xml"
        $templates =  [xml](Get-Content -Path $Template_XML_File)

    # Based on the Department Passed in, get the Proper Template
        $matchingDepartment = $templates.SelectNodes("//Department[@name='$Dept']")
        $Department_name = $matchingDepartment.name;

        if ($Department_name) {

            switch ($Department_name) {
                "Administration" {
                        $Mirror_template = $matchingDepartment.Base_User_Template
                }
                "Administration and Finance" {
                        $Mirror_template = $matchingDepartment.Base_User_Template
                }
                "Billing" {
                    if($Newhire.title -match "Trainee - Billing" ){
                        $Mirror_template = $matchingDepartment.Base_User_Trainee_Template
                    }
                    else {
                        $Mirror_template = $matchingDepartment.Base_User_Template
                    }
                }
                "Billing Operations" {
                    $Mirror_template = $matchingDepartment.Base_User_Template
                }
                "Business Transformation" {
                    $Mirror_template = $matchingDepartment.Base_User_Template
                }
                "Coding" {
                    $Mirror_template = $matchingDepartment.Base_User_Template
                }
                "Finance" {
                    $Mirror_template = $matchingDepartment.Base_User_Template
                }
                "Human Resources" {
                    $Mirror_template = $matchingDepartment.Base_User_Template
                }
                "Integration Services" {
                    $Mirror_template = $matchingDepartment.Base_User_Template
                }
                "IT Development" {
                    $Mirror_template = $matchingDepartment.Base_User_Template
                }
                "IT Infrastructure" {
                    $Mirror_template = $matchingDepartment.Base_User_Template
                }
                "LogixHealth India" {
                    $Mirror_template = $matchingDepartment.Base_User_Template
                }
                "Operations" {
                    $Mirror_template = $matchingDepartment.Base_User_Template
                }
                "Provider Reimbursement" {
                    $Mirror_template = $matchingDepartment.Base_User_Template
                }
                "RCM Operations" {
                    $Mirror_template = $matchingDepartment.Base_User_Template
                }
                "Strategic Operations" {
                    $Mirror_template = $matchingDepartment.Base_User_Template
                }
                "Talent Transformation" {
                    $Mirror_template = $matchingDepartment.Base_User_Template
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
#Get the Destination OU and Move the User locaiton. Have to do this for te whole destination String it it exisit .Replace("&", "and")
# if the user is MGMT then also set the destination to "OU=Patient Call Center Supervisor Users,OU=Patient Call Center Users,OU=Department Users,OU=Internal,OU=Bedford,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
function Get-DestinationOU {
    param (
        [string]$Department
    )
    $Department = $Newhire.Department
    $Dept = $Department.Replace("&", "and")
    
#Replace any & with AND
# Read in the Template File
    $Template_XML_File = "\\Bedpautosprt001\d$\LHI_Support\Scripts\Creat-NewHire\src\Template_Strucutre_Coimbatore.xml"
    $templates =  [xml](Get-Content -Path $Template_XML_File)

# Based on the Department Passed in, get the Proper Template
    $matchingDepartment = $templates.SelectNodes("//Department[@name='$Dept']")
    $Department_name = $matchingDepartment.name;

    if ($Department_name) {

        switch ($Department_name) {
            "Administration" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Administration and Finance" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Billing" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Billing Operations" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Business Transformation" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Coding" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Finance" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Human Resources" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Integration Services" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "IT Development" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "IT Infrastructure" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "LogixHealth India" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Operations" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Provider Reimbursement" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "RCM Operations" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Strategic Operations" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            "Talent Transformation" {
                $destination_path = $matchingDepartment.AD_Destination_OU
            }
            default {
                # Action for any other department not listed above
                Write-Host "Unknown department: $Department"
                # Add your specific code here
            }
        }
    return $destination_path
    } else {
        return "Department '$Department' not found in the XML."
    }

}

#Create New Hire, pass in the template and the rest of the info from the Ticket and the Avaliable UserName Function
function Create_NewHire {
    param (
        [string]$Title,
        [string]$Department,
        [string]$FirstName,
        [string]$LastName,
        [string]$Manager,
        [string]$SAMAccountName,
        [string]$Mirror_template,
        [string]$destination_path,
        [string]$Office,
        [string]$EmployeeID
    )

    # Correct variable names
    $Title =  $Newhire.Title
    $Department =  $Newhire.department
    $FirstName =  $Newhire.FirstName
    $LastName =  $Newhire.LastName
   
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
        SamAccountName          = $Newhire.SAMAccountName
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
    
        $Manager_name =  $Newhire.Manager
        #Setting the Manager
        #Bsed on the Display Name get the users SameAccountName
        $managerUsername = Get-ADUser -Filter "DisplayName -like '$Manager_name*'" | Select SamAccountName
        $managerUsername
Start-Sleep -Seconds 3
        #Set the new hires Manager
        Set-ADUser -Identity $Newhire.SAMAccountName -Manager $managerUsername
Start-Sleep -Seconds 3
 #Set the new hires EmployeeID
 $id = $newhire.EmployeeID
 Set-ADUser -Identity $Newhire.SAMAccountName -Add @{employeeID="$id"}
 Start-Sleep -Seconds 3
        #Get New users Guid
        $userIdentity = Get-aduser $Newhire.SAMAccountName -Properties * 
        $userIdentity.ObjectGUID
 Start-Sleep -Seconds 3       
        #Get the OUs Guid
        $destination_path = $destination_path.Replace('"', '')
        $Ou_guid = Get-ADOrganizationalUnit $destination_path | select ObjectGUID
        $Ou_guid.ObjectGUID
Start-Sleep -Seconds 3
    #Set the User Extra Attributes 8 for BUILDING and Extensionattribute11 as MFA
       #Set-ADUser -Identity $userIdentity.SamAccountName -Add @{extensionattribute8="Corporate"}
       #Set-ADUser -Identity $userIdentity.SamAccountName -Add @{extensionattribute11="Remote"}

Start-Sleep -Seconds 3
        #Move the user to the proper OU
        Move-ADObject -Identity $userIdentity.ObjectGUID -TargetPath $Ou_guid.ObjectGUID
        Write-Host "New user created and properties copied successfully."

}

# Import the Template to create new hire
 $file_path = Read-Host "Enter the New Hire Tempalte Path. MAKE SURE there are no space in the Path)"
 $NewHires = Import-Csv -Path $file_path

foreach ($Newhire in $NewHires) {
    # Get the Template
    $Mirror_template = Get-TemplateInfo -Department $Newhire.department -Title $Newhire.Title
    Write-Output ("Template to Mirror: $Mirror_template")
    $Mirror_template = $Mirror_template.Replace('"', '')

    # Get the path and pass it into the New Hire function
    $destination_path = Get-DestinationOU -Department $Newhire.department
    Write-Output ("Destination User OU: $destination_path")

    # Start-Sleep -Seconds 3
    $NewHire = Create_NewHire -Title $Newhire.Title -Department $Newhire.department -FirstName $Newhire.FirstName -LastName $Newhire.LastName -Manager $Newhire.Manager -SAMAccountName $Newhire.SamAccountName -Mirror_template $Mirror_template -destination_path $destination_path -Office $Newhire.office -EmployeeID $Newhire.EmployeeID
    Write-Output ($NewHire)
}

# Stop logging
Stop-Transcript





