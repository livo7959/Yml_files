targetScope = 'managementGroup'

module rg 'modules/namingConvention.bicep' = {
  name: 'policy-resourceGroup-naming-convention'
  params: {
    textPattern: 'rg-*'
    policyName: 'policy-resourceGroup-naming-convention'
    assignmentDisplayName: 'assignment-resourceGroup-naming-convention'
    assignmentName: 'assignment-rg-policy'
    type: 'Microsoft.Resources/subscriptions/resourceGroups'
    policyDescription: 'Enforces resource group names to being with rg-'
  }
}
