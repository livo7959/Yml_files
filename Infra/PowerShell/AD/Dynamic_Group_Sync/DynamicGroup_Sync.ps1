<#

    .SYNOPSIS
        Syncs the AD Group
            $ADGroupname = 'Technology_OU_All_Users'
            $GroupName = "AZDO_BusinessUnits"
            AD Group and adds any new onborder user from (CORP.LOGIXHEALTH.LOCAL) to be syncd up to Azure Devops.

    .DESCRIPTION
            Syncs the AD Group "AZDO_BusinessUnits" AD Group that will be granted access to AZDO access groups Board_Only_Contributors.
            The script will also logs who is remvoed and whon is added, there will be sync that runs nightly.
            Exludes the following type of accounts: Service Accounts, Disabled Accounts remvoe and log.

    .PARAMETER Name
            Script Name: DynamicGroup_Sync.ps1

    .OUTPUTS
            Log file path: D:\Logs\Dynamic_Group_Sync

    .LINK
            AZDO Login: https://azuredevops.logixhealth.com/LogixHealth

#>

# Dynamic group name for Technology OU
$ADGroupname = 'Technology_OU_All_Users'
$GroupName = "AZDO_BusinessUnits"

# Export Path
$path = "D:\Logs\Dynamic_Group_Sync\"
$strDate = (Get-Date -Format 'MM_dd_yyyy')

# Function to log messages
function Write-Log {
  param (
    [string]$message,
    [string]$logFile
  )
  $logMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $message"
  Add-Content -Path $logFile -Value $logMessage
}

# Function to sync Technology OU users
function Sync-TechnologyOU {
  # Get users from specified departments
  $users = Get-ADUser -Filter { department -like "Infrastructure & Security" -or
    department -like "Analytics and Innovation" -or
    department -like "Software Development" -or
    department -like "IT Development" -or
    department -like "IT Infrastructure" -or
    department -like "Technology" -or
    department -like "Data & Analytics" -or
    department -like "Corporate and Practice Strategies" } -Properties *

  # Filter enabled users excluding certain prefixes
  $filteredUsers = $users | Where-Object {
    $_.Enabled -eq $true -and
    $_.Name -notmatch '^(admin_|dev|BED|logix|tsroute|Test|Icer)'
  } | Select-Object -ExpandProperty SamAccountName

  # Get current group members
  $Current_Users = Get-ADGroupMember $ADGroupname | Select-Object -ExpandProperty SamAccountName

  # Compare and sync users
  $diff = Compare-Object $filteredUsers $Current_Users -IncludeEqual
  $added_users = @()
  $removed_users = @()

  # Remove users not in the OU
  $diff | Where-Object { $_.SideIndicator -eq '=>' } | ForEach-Object {
    Remove-ADGroupMember -Identity $ADGroupname -Members $_.InputObject -Confirm:$false
    $removed_users += $_.InputObject
  }

  # Add users in the OU
  $diff | Where-Object { $_.SideIndicator -eq '<=' } | ForEach-Object {
    Add-ADGroupMember -Identity $ADGroupname -Members $_.InputObject
    $added_users += $_.InputObject
  }

  # Export logs
  $excelPath = "$($path)\TechOU_User_Update_log_$strDate.xlsx"
  $added_users | Export-Excel -Path $excelPath -WorksheetName "Added User" -TableName misc -TableStyle medium6 -FreezePane 3 -Title "Report prepared on: $(Get-Date -Format 'MM/dd/yyyy')" -TitleSize 13 -AutoSize
  if ($removed_users) {
    $removed_users | Export-Excel -Path $excelPath -WorksheetName "Removed User" -TableName misc -TableStyle medium6 -FreezePane 3 -Title "Report prepared on: $(Get-Date -Format 'MM/dd/yyyy')" -TitleSize 13 -AutoSize
  }
}

# Function to sync AZDO Business Units
function Sync-AZDOBusinessUnits {
  $LogFile = "D:\Logs\Dynamic_Group_Sync\AZDOBusinessUnitesADGroup_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').log"
  Write-Log "Script started." $LogFile

  # Define departments
  $departments = @("Coding", "ED Billing", "Billing Operations", "Medical Records Administration",
    "Coding Quality", "Cash Management", "Coding Applications", "EDI",
    "Operations", "Client Services", "Billing Applications", "Specialty Billing",
    "Provider Education", "Coding Operations", "Billing", "Provider Enrollment", "Reimbursement", "Revenue Integrity",
    "Operational Excellence", "Audit & Contracting", "Communications")

  # Get enabled AD users filtered by department and email domain
  $users = Get-ADUser -Filter { Enabled -eq $true } -Properties DisplayName, SamAccountName, Department, EmailAddress |
  Where-Object { $departments -contains $_.Department -and $_.EmailAddress -like "*@logixhealth.com" } |
  Sort-Object DisplayName |
  Select-Object DisplayName, SamAccountName

  Write-Log "Retrieved $($users.Count) enabled users." $LogFile

  # Filter out service accounts and other criteria
  $filteredUsers = $users | Where-Object {
    $_.SamAccountName -notlike "QA Test*" -and
    $_.SamAccountName -notlike "SVC_*" -and
    $_.SamAccountName -notlike "PRD_*" -and
    $_.SamAccountName -notlike "Kitchen*" -and
    $_.SamAccountName -notlike "Dev_*" -and
    $_.SamAccountName -notlike "admin_*" -and
    $_.SamAccountName -notlike "DA*" -and
    $_.SamAccountName -notlike "CRM*" -and
    $_.SamAccountName -notlike "conf*" -and
    $_.SamAccountName -notlike "BED*m" -and
    $_.SamAccountName -notlike "Acel*" -and
    $_.SamAccountName -notlike "AD manger*" -and
    $_.DisplayName -ne $null -and
    $_.DisplayName -ne "" -and
    $_.SamAccountName -notmatch "^[0-9]"
  }

  Write-Log "Filtered down to $($filteredUsers.Count) users." $LogFile

  # Sync users with the AZDO group
  $groupMembers = Get-ADGroupMember -Identity $GroupName | Select-Object -ExpandProperty SamAccountName
  $newUsers = @()
  $existingUsers = @()

  foreach ($user in $filteredUsers) {
    if ($groupMembers -notcontains $user.SamAccountName) {
      Add-ADGroupMember -Identity $GroupName -Members $user.SamAccountName -Confirm:$false
      Write-Log "Added $($user.SamAccountName) to $GroupName." $LogFile
      $newUsers += $user
    }
    else {
      $existingUsers += $user
    }
  }

  Write-Log "Found $($newUsers.Count) new users and $($existingUsers.Count) existing users." $LogFile

  # Remove disabled users from the group
  $disabledGroupMembers = Get-ADGroupMember -Identity $GroupName | Where-Object {
        (Get-ADUser -Identity $_.SamAccountName).Enabled -eq $false
  }

  $removedUsers = @()

  foreach ($disabledUser in $disabledGroupMembers) {
    Remove-ADGroupMember -Identity $GroupName -Members $disabledUser.SamAccountName -Confirm:$false
    Write-Log "Removed disabled user $($disabledUser.SamAccountName) from $GroupName." $LogFile
    $removedUsers += $disabledUser
  }

  # Prepare data for CSV
  $csvData = $filteredUsers | Select-Object DisplayName, SamAccountName,
  @{Name = "Status"; Expression = { if ($newUsers -contains $_) { "New" } else { "Existing" } } },
  @{Name = "AddedToGroup"; Expression = { if ($newUsers -contains $_) { "Yes" } else { "No" } } },
  @{Name = "RemovedFromGroup"; Expression = { if ($removedUsers -contains $_) { "Yes" } else { "No" } } }

  # Export to CSV
  $csvFile = "D:\Logs\Dynamic_Group_Sync\AZDOBusinessUnitesADGroup_$($DateTime.Replace(':', '-')).csv"
  $csvData | Export-Csv -Path $csvFile -NoTypeInformation

  # Display the filtered users
  $filteredUsers
}

# Execute the functions
Sync-TechnologyOU
Sync-AZDOBusinessUnits
