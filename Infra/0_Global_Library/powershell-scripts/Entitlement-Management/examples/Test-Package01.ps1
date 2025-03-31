$Resources = @(
    @{Type="AadGroup"; Id="301bbb5a-08a7-4247-9886-637746705979"; Role="Member"},
    @{Type="SharePointOnline"; Id="https://logixhealthinc.sharepoint.com/sites/LHInfrastructure451-PKIProject"; Role="Member"},
    @{Type="AadApplication"; Id="8890563f-5fca-4274-a0c3-b36d55773dc6"; Role="User"}
)

Write-Output $Resources


# Run the script
..\infrastructure\0_Global_Library\powershell-scripts\Entitlement-Management\Create-AccessPackage.ps1 `
    -CatalogName "Script Test Catalog 01" `
    -AccessPackageName "Script Test Package 01" `
    -PolicyName "Script Test Policy 01"
    -Resources $Resources
    -AutoAssignmentMembershipRule '(user.mail -eq "user@gmail.com")'
    # -CreateAssignmentPolicy $true `
    # -CreateAutoAssignmentPolicy $true `
    # -RequestorSettings $RequestorSettings `
    # -RequestApprovalSettings $RequestApprovalSettings `
    # -AccessReviewSettings $AccessReviewSettings `
    # -ExpirationSettings $ExpirationSettings `
    # -IsExtensionEnabled $true `
    # -ExtensionDays 30

