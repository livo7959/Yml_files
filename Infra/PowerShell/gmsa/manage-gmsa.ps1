<#
.SYNOPSIS
    This script manages Group Managed Service Accounts (gMSA) using PowerShell, which requires the AD PowerShell Module. It can create, modify, add, or update gMSA objects based on the provided flags. Always follow the principle of Least Privilege; do not give the service account administrator permissions on the server it’s being used on.

.DESCRIPTION
    The script has the folowing functions:
    Create-GMSA
    Check-Gmsa
    Add-ServersToGmsa
    Remove-ServerAccessFromGmsa
    Add-SecurityGroupsToGmsa
    Remove-SecurityGroupsFromGmsa

  For more information, refer to the online documentation:
    https://learn.microsoft.com/en-us/powershell/module/activedirectory/new-adserviceaccount?view=windowsserver2016-ps&redirectedfrom=MSDN

.REQUIRED PARAMETERS
    Naming Convention:
        - gmsa_serviceName: Must be 15 characters or less.

    Organizational Units:
        - GMSA Service Accounts:
          OU=Managed SA,OU=Service Accounts,OU=_IT Administration,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL
        - GMSA Groups:
          OU=Managed SA Groups,OU=Security Groups,OU=Service Accounts,OU=_IT Administration,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL

    Name: gmsa_serviceName
    DNSHostName: serviceName.corp.logixhealth.local
        - Required for registering SPNs for cluster names (e.g., Failover clustering or SQL Always On).
    KerberosEncryptionType: AES256
    OU: See above
    PrinciplesAllowedToRetrieveManagedPassword:
        - Can be a single computer object, group of computers, or both. Recommended to use a group if the credential is used by more than one computer.


.COMMON ACCOUNT TYPES COMPATIBLE WITH GMSA
    - Windows Service Accounts (services.msc)
    - SQL Service Accounts
    - IIS App Pool accounts (if NOT using physical path credentials)
    - Scheduled Tasks
    - File Share manipulation tasks
    - Defender for Identity
#>

function Create-Gmsa {
  <#
  .SYNOPSIS
  Creates a Group Managed Service Account (GMSA).

  .DESCRIPTION
  The Create-GMSA function creates a new Group Managed Service Account (GMSA) in Active Directory. It requires the name of the GMSA and the servers that are allowed to retrieve the managed password.

  .PARAMETER Name
  The name of the GMSA to create.

  .PARAMETER Description
  A description for the GMSA.

  .PARAMETER Servers
  An array of server names that are allowed to retrieve the managed password for the GMSA.

  .EXAMPLE
  PS> Create-GMSA -Name "gmsa_name$" -Description "Service account for MyApp" -Servers "Server1$", "Server2$"

  This command creates a GMSA named "gmsa_name$" with the specified description and allows "Server1" and "Server2" to retrieve the managed password.

#>

  param (
    [string]$name,
    [string]$description,
    [string[]]$servers
  )

  if (-not $name -or -not $servers) {
    Write-Error "Name and Servers parameters are required for creating a GMSA."
    return
  }
  try {
    New-ADServiceAccount -Name $name -DNSHostName gmsa_serviceName.corp.logixhealth.local -KerberosEncryptionType AES256 -PrincipalsAllowedToRetrieveManagedPassword $servers -Path "OU=Managed SA,OU=Service Accounts,OU=_IT Administration,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL" -Description $description
    $gmsa = Get-ADServiceAccount -Identity $name -Properties PrincipalsAllowedToRetrieveManagedPassword, Description
    if ($gmsa) {
      $gmsa | fl
    }
    else {
      Write-Error "Failed to retrieve the GMSA account after creation."
    }
  }
  catch {
    Write-Error "An error occurred while creating the GMSA account: $_"
  }
}

function Check-Gmsa {
  <#
  .SYNOPSIS
  Checks the details of a Group Managed Service Account (GMSA).

  .DESCRIPTION
  The Check-Gmsa function retrieves and displays the details of a specified GMSA, including the principals allowed to retrieve the managed password and the groups the GMSA is a member of.

  .PARAMETER Name
  The name of the GMSA to check.

  .EXAMPLE
  PS> Check-Gmsa -Name "gmsa_name$"
  This command retrieves and displays the details of the GMSA named "gmsa_name$".

#>

  param (
    [string]$name
  )

  if (-not $name) {
    Write-Error "Name parameter is required for checking a GMSA."
    return
  }
  try {
    $serviceAccount = Get-ADServiceAccount -Identity $name -Properties PrincipalsAllowedToRetrieveManagedPassword, Description, MemberOf
    if ($serviceAccount) {
      $cnList = $serviceAccount.PrincipalsAllowedToRetrieveManagedPassword | ForEach-Object {
        if ($_ -match 'CN=([^,]+)') {
          $matches[1]
        }
      }

      $fsgroups = $serviceAccount.MemberOf | ForEach-Object {
        if ($_ -match 'CN=([^,]+)') {
          $matches[1]
        }
      }

      $result = [PSCustomObject]@{
        Name                                       = $serviceAccount.Name
        Description                                = $serviceAccount.Description
        PrincipalsAllowedToRetrieveManagedPassword = $cnList -join ";"
        Access_groups                              = $fsgroups -join ";"
      }
      $result | fl
    }
    else {
      Write-Error "Failed to retrieve the GMSA account."
    }
  }
  catch {
    Write-Error "An error occurred while checking the GMSA account: $_"
  }
}

function Add-ServersToGmsa {
  <#
    .SYNOPSIS
    Adds servers to a Group Managed Service Account (GMSA).

    .DESCRIPTION
    The Add-ServersToGmsa function adds specified servers to the list of principals allowed to retrieve the managed password for a GMSA.

    .PARAMETER Name
    The name of the GMSA to update.

    .PARAMETER Servers
    An array of server names to add to the GMSA.

    .EXAMPLE
    PS> Add-ServersToGmsa -Name "gmsa_name$" -Servers "Server1$", "Server2$"
    This command adds "Server1" and "Server2" to the GMSA named "gmsa_name$".

  #>

  param (
    [string]$name,
    [string[]]$servers
  )

  if (-not $name -or -not $servers) {
    Write-Error "Name and Servers parameters are required for adding servers."
    return
  }
  try {
    $serviceAccount = Get-ADServiceAccount -Identity $name -Properties PrincipalsAllowedToRetrieveManagedPassword
    if ($serviceAccount) {
      $currentServers = $serviceAccount.PrincipalsAllowedToRetrieveManagedPassword
      $allServers = $currentServers + $servers | Select-Object -Unique
      Set-ADServiceAccount -Identity $name -PrincipalsAllowedToRetrieveManagedPassword $allServers
      Write-Output "Servers successfully added to the GMSA account."
    }
    else {
      Write-Error "Failed to retrieve the GMSA account."
    }
  }
  catch {
    Write-Error "An error occurred while adding servers to the GMSA account: $_"
  }
}

function Remove-ServerAccessFromGmsa {
  <#
    .SYNOPSIS
    Removes all server access from a Group Managed Service Account (GMSA).

    .DESCRIPTION
    The Remove-ServerAccessFromGmsa function removes all servers from the list of principals allowed to retrieve the managed password for a GMSA.

    .PARAMETER Name
    The name of the GMSA to update.

    .EXAMPLE
    PS> Remove-ServerAccessFromGmsa -Name "gmsa_name$"
    This command removes all server access from the GMSA named "gmsa_name$".

    .OUTPUTS
    System.String. The function returns a message indicating the result of the operation.

  #>

  param (
    [string]$name
  )

  if (-not $name) {
    Write-Error "Name parameter is required for removing server access."
    return
  }
  Set-ADServiceAccount -Identity $name -PrincipalsAllowedToRetrieveManagedPassword @()

  Check-Gmsa $name
}

function Add-SecurityGroupsToGmsa {
  <#
    .SYNOPSIS
    Adds security groups to a Group Managed Service Account (GMSA).

    .DESCRIPTION
    The Add-SecurityGroupsToGmsa function adds specified security groups to a GMSA.

    .PARAMETER Name
    The name of the GMSA to update.

    .PARAMETER SecurityGroups
    An array of security group names to add to the GMSA.

    .EXAMPLE
    PS> Add-SecurityGroupsToGmsa -Name "gmsa_name$" -SecurityGroups "Group1", "Group2"
    This command adds "Group1" and "Group2" to the GMSA named "gmsa_name$".

  #>

  param (
    [string]$name,
    [string[]]$security_groups
  )

  if (-not $name -or -not $security_groups) {
    Write-Error "Name and SecurityGroups parameters are required for adding security groups."
    return
  }
  foreach ($group in $security_groups) {
    try {
      $groupExists = Get-ADGroup -Identity $group -ErrorAction Stop
      if ($groupExists) {
        Add-ADGroupMember -Identity $group -Members $name
        $memberCheck = Get-ADGroupMember -Identity $group | Where-Object { $_.SamAccountName -eq $name }
        if ($memberCheck) {
          Write-Output "Successfully added $name to $group."
          Check-Gmsa $name
        }
        else {
          Write-Error "Failed to add $name to $group."
        }
      }
    }
    catch {
      Write-Error "Group $group does not exist or an error occurred: $_"
    }
  }
}

function Remove-SecurityGroupsFromGmsa {
  <#
    .SYNOPSIS
    Removes security groups from a Group Managed Service Account (GMSA).

    .DESCRIPTION
    The Remove-SecurityGroupsFromGmsa function removes all security groups from a specified GMSA.

    .PARAMETER Name
    The name of the GMSA to update.

    .EXAMPLE
    PS> Remove-SecurityGroupsFromGmsa -Name "gmsa_name$"
    This command removes all security groups from the GMSA named "gmsa_name$".

  #>

  param (
    [string]$name
  )

  if (-not $name) {
    Write-Error "Name parameter is required for removing server access."
    return
  }
  try {
    $serviceAccount = Get-ADServiceAccount -Identity $name -Properties MemberOf
    if ($serviceAccount) {
      $groups = $serviceAccount.MemberOf
      foreach ($group in $groups) {
        try {
          Remove-ADGroupMember -Identity $group -Members $name -Confirm:$false
          Write-Output "Successfully removed $name from $group."
          Check-Gmsa $name
        }
        catch {
          Write-Error "Failed to remove $name from $group - $_"
        }
      }
    }
    else {
      Write-Error "Failed to retrieve the GMSA account."
    }
  }
  catch {
    Write-Error "An error occurred while removing the GMSA account from groups: $_"
  }
}
