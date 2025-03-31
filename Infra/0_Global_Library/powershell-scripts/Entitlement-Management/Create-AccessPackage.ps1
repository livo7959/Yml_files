
param (
    [Parameter(Mandatory=$false)]
    [string]$CatalogId,

    [Parameter(Mandatory=$true)]
    [string]$CatalogName,

    [Parameter()]
    [bool]$CatalogExternallyVisible = $false,

    [Parameter(Mandatory=$true)]
    [string]$AccessPackageName,

    [Parameter(Mandatory=$true)]
    [string]$PolicyName,

    [Parameter(Mandatory=$false)]
    [string]$CatalogDescription,

    [Parameter(Mandatory=$false)]
    [string]$MembershipRule,

    [Parameter()]
    [string]$TenantId,

    [Parameter()]
    [string]$ClientId,

    [Parameter()]
    [string]$CertificateThumbprint,

    [Parameter(Mandatory=$true)]
    [array]$Resources,

    [Parameter()]
    [string]$AutoAssignmentMembershipRule,

    [Parameter(Mandatory=$false)]
    [bool]$CreateAssignmentPolicy = $false,

    [Parameter(Mandatory=$false)]
    [hashtable]$RequestorSettings,

    [Parameter(Mandatory=$false)]
    [hashtable]$RequestApprovalSettings,

    [Parameter(Mandatory=$false)]
    [hashtable]$AccessReviewSettings,

    [Parameter(Mandatory=$false)]
    [hashtable]$ExpirationSettings

  )

# Install the Microsoft Graph PowerShell SDK if not already installed
# Install-Module Microsoft.Graph -Scope CurrentUser
# Install-Module Microsoft.Graph.Beta -Scope CurrentUser

# Authenticate as a service principal using a certificate
# $Cert = Get-Item -Path "Cert:\CurrentUser\My\$CertificateThumbprint"
# Connect-MgGraph -ClientId $ClientId -TenantId $TenantId -Certificate $Cert

# Generate a timestamp for the log file
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# Set the log file path
if (-not $LogFilePath) {
  $LogFilePath = "$env:USERPROFILE\.Create-AccessPackage\Create-AccessPackage_$Timestamp.log"
} else {
  $LogFilePath = "$LogFilePath\Create-AccessPackage_$Timestamp.log"
}

# Create the log directory if it does not exist
$LogDirectory = [System.IO.Path]::GetDirectoryName($LogFilePath)

if (-not (Test-Path -Path $LogDirectory)) {
    New-Item -Path $LogDirectory -ItemType Directory | Out-Null
}

# Function to log messages
function Write-Log {
    param (
        [string]$Message
    )
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "$Timestamp - $Message"
    Add-Content -Path $LogFilePath -Value $LogEntry
}

# Function to add resources to the catalog
function Add-ResourceToCatalog {
    param (
        [string]$ResourceType,
        [string]$ResourceId,
        [string]$CatalogId
    )

    $ResourceParams = @{
        requestType = "adminAdd"
        resource = @{
            originId = $ResourceId
            originSystem = $ResourceType
        }
        catalog = @{
            id = $CatalogId
        }
    }

    try {
        New-MgEntitlementManagementResourceRequest -BodyParameter $ResourceParams
        Write-Log "Added $ResourceType resource with ID $ResourceId to catalog $CatalogId."
    } catch {
        Write-Log "Failed to add $ResourceType resource with ID $ResourceId to catalog $CatalogId. Error: $_"
    }
}

# Test if the Catalog already exists
$Catalog = Get-MgEntitlementManagementCatalog -Filter "displayName eq '$CatalogName'" -All -ExpandProperty Resources,AccessPackages

# Use existing catalog or create a new one
if ($null -eq $Catalog) {
    Write-Host "$CatalogName not found. Creating new Catalog" -ForegroundColor Yellow

    $NewCatalog = @{
        displayName = $CatalogName
        description = $CatalogDescription
        isExternallyVisible = $CatalogExternallyVisible
    }
    $Catalog = New-MgEntitlementManagementCatalog -BodyParameter $NewCatalog

    Write-Host "Catalog '$CatalogName' created successfully." -ForegroundColor Green
}

# Loop through resources and add them to the catalog
foreach ($Resource in $Resources) {
    Write-Output "Resource Type: $($Resource.Type), Resource ID: $($Resource.Id)"
    Add-ResourceToCatalog -ResourceType $Resource.Type -ResourceId $Resource.Id -CatalogId $Catalog.Id
}

# Create the access package if it doesn't already exist

try {
  # Attempt to get the access package
  $AccessPackage = Get-MgEntitlementManagementAccessPackage -Filter "displayName eq '$AccessPackageName'"

  if ($AccessPackage) {
      Write-Output "Access package '$AccessPackageName' already exists."
  } else {
      # Define the parameters for the new access package
      $apParams = @{
          displayName = $AccessPackageName
          description = $CatalogDescription
          isHidden = $false
          catalog = @{
              id = $Catalog.Id
          }
      }
      # Create the new access package
      $AccessPackage = New-MgEntitlementManagementAccessPackage -BodyParameter $apParams
      Write-Output "Access package '$AccessPackageName' created successfully."
  }
} catch {
  Write-Error "An error occurred: $_"
  Write-Log -Message "An error occurred: $_"
}

#$AccessPackage = New-MgEntitlementManagementAccessPackage -DisplayName $AccessPackageName -Catalog "$Catalog.Id" -Description $CatalogDescription

# Function to add resource roles to the access package
function Add-ResourceRoleToAccessPackage {
    param (
        [string]$ResourceType,
        [string]$ResourceId,
        [string]$CatalogId,
        [string]$AccessPackageId,
        [string]$Role
    )

    # The following is a `if` statement per resource type. The roles are different between resources and must be looked up.
    # Therefore we are currently separating them and accepting some code duplication.

    # Process SharePoint Online Resource roles
    if ($ResourceType -eq "SharePointOnline") {
      $spResource = Get-MgEntitlementManagementCatalogResource -AccessPackageCatalogId $CatalogId -Filter "originId eq '$ResourceID'"

      $spResourceRole = Get-MgEntitlementManagementCatalogResourceRole -AccessPackageCatalogId $CatalogId -Filter "(OriginSystem eq '$($spResource.OriginSystem)' and resource/id eq '$($spResource.Id)')" -ExpandProperty "resource" | Where-Object {$_.DisplayName -like "*$Role*"}

      $spParams = @{
        role = @{
          displayName = $spResourceRole.DisplayName
          originSystem = "SharePointOnline"
          originId = $spResourceRole.OriginId
          resource = @{
            id = $spResource.Id
          }
        }
        scope = @{
          displayName = "Root"
          description = "Root Scope"
          originId = $spResource.OriginId
          originSystem = "SharePointOnline"
          isRootScope = $true
        }
      }

        try {

          New-MgEntitlementManagementAccessPackageResourceRoleScope -AccessPackageId $AccessPackageId -BodyParameter $spParams
          Write-Log "Added $ResourceType resource role to access package $AccessPackageId."

      } catch {
          Write-Log "Failed to add $ResourceType resource role to access package $AccessPackageId. Error: $_"
      }
    }

    # Process Entra ID Groups
    if ($ResourceType -eq "AadGroup") {

      Write-Output $ResourceId

      $groupResource = Get-MgEntitlementManagementCatalogResource -AccessPackageCatalogId $CatalogId -Filter "originId eq '$ResourceID'" -ExpandProperty "scopes"

      $groupResourceScope = $groupResource.Scopes[0]

      $groupResourceRole = Get-MgEntitlementManagementCatalogResourceRole -AccessPackageCatalogId $CatalogId -Filter "(OriginSystem eq '$($groupResource.OriginSystem)' and displayName eq 'Member' and resource/id eq '$($groupResource.Id)')" -ExpandProperty "resource"

      $groupParams = @{
        role = @{
          id = $groupResourceRole.Id
          displayName = $groupResourceRole.DisplayName
          originSystem = "AadGroup"
          originId = $groupResourceRole.OriginId
          resource = @{
            id = $groupResource.Id
            originId = $groupResource.OriginId
            originSystem = $groupResource.originSystem
          }
        }
        scope = @{
          id = $groupResourceScope.Id
          displayName = "Root"
          description = "Root Scope"
          originId = $groupResource.OriginId
          originSystem = "AadGroup"
          isRootScope = $true
        }
      }

        try {

          New-MgEntitlementManagementAccessPackageResourceRoleScope -AccessPackageId $AccessPackageId -BodyParameter $groupParams
          Write-Log "Added $ResourceType resource role to access package $AccessPackageId."

      } catch {
          Write-Log "Failed to add $ResourceType resource role to access package $AccessPackageId. Error: $_"
      }
    }

    # Process Entra ID Applications
    if ($ResourceType -eq "AadApplication") {
      $appResource = Get-MgEntitlementManagementCatalogResource -AccessPackageCatalogId $CatalogId -Filter "originId eq '$ResourceID'" -ExpandProperty "scopes"

      $appResourceScope = $appResource.Scopes[0]

      $appResourceRole = Get-MgEntitlementManagementCatalogResourceRole -AccessPackageCatalogId $CatalogId -Filter "(OriginSystem eq '$($appResource.OriginSystem)' and displayName eq 'User' and resource/id eq '$($appResource.Id)')" -ExpandProperty "resource"

      $appParams = @{
        role = @{
          id = $appResourceRole.Id
          displayName = $appResourceRole.DisplayName
          originSystem = "AadApplication"
          originId = $appResourceRole.OriginId
          resource = @{
            id = $appResource.Id
            originId = $appResource.OriginId
            originSystem = $appResource.originSystem
          }
        }
        scope = @{
          id = $appResourceScope.Id
          displayName = "Root"
          description = "Root Scope"
          originId = $appResource.OriginId
          originSystem = "AadApplication"
          isRootScope = $true
        }
      }

        try {

          New-MgEntitlementManagementAccessPackageResourceRoleScope -AccessPackageId $AccessPackageId -BodyParameter $appParams
          Write-Log "Added $ResourceType resource role to access package $AccessPackageId."

      } catch {
          Write-Log "Failed to add $ResourceType resource role to access package $AccessPackageId. Error: $_"
      }
    }
}

# Add resource roles to the access package
foreach ($Resource in $Resources) {
    Add-ResourceRoleToAccessPackage -ResourceType $Resource.Type -ResourceId $Resource.Id -Role $Resource.Role -CatalogId $Catalog.Id -AccessPackageId $AccessPackage.Id
}

# Create Auto Assignment Policy if the $AutoAssignmentMembership Rule Parameter is passed.
if ($null -ne $AutoAssignmentMembershipRule) {
  # Define the policy display name
  $PolicyDisplayName = "$($AccessPackageName)-Auto-Assignment-Policy"

  # Check if the policy already exists
  $ExistingPolicy = Get-MgEntitlementManagementAssignmentPolicy -Filter "displayName eq '$policyDisplayName'"

  if (-not $existingPolicy) {
      # Define the policy parameters
      $assParams = @{
          displayName = "$($AccessPackageName)-Auto-Assignment-Policy"
          description = "$($AccessPackageName) Auto Assignment Policy"
          allowedTargetScope = "specificDirectoryUsers"
          specificAllowedTargets = @(
              @{
                  "@odata.type" = "#microsoft.graph.attributeRuleMembers"
                  description = "Auto assignment Membership Rule"
                  membershipRule = $AutoAssignmentMembershipRule
              }
          )
          automaticRequestSettings = @{
              requestAccessForAllowedTargets = $true
              removeAccessWhenTargetLeavesAllowedTargets = $true
              gracePeriodBeforeAccessRemoval = "P7D"
          }
          accessPackage = @{
              id = $AccessPackage.Id
          }
      }

      # Create the policy
      New-MgEntitlementManagementAssignmentPolicy -BodyParameter $assParams
  } else {
      Write-Output "Policy '$PolicyDisplayName' already exists."
      Write-Log -Message "Policy '$PolicyDisplayName' already exists."
  }
} else {
  Write-Output "AutoAssignmentMembershipRule parameter is not provided."
}


# Create assignment policy if required
if ($CreateAssignmentPolicy) {
    try {
        $AssignmentPolicy = New-MgEntitlementManagementAccessPackageAssignmentPolicy -DisplayName $PolicyName -AccessPackageId $AccessPackage.Id -Description $CatalogDescription -RequestorSettings $RequestorSettings -RequestApprovalSettings $RequestApprovalSettings -AccessReviewSettings $AccessReviewSettings -ExpirationSettings $ExpirationSettings
        Write-Log "Assignment policy created successfully."
    } catch {
        Write-Log "Failed to create assignment policy. Error: $_"
    }
}

Write-Log "Catalog, access package, and resources created successfully."
