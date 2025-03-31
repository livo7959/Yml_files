targetScope = 'managementGroup'

module rg 'modules/namingConvention.bicep' = {
  name: 'policy-vnet-naming-convention'
  params: {
    textPattern: 'vnet-*'
    policyName: 'policy-vnet-naming-convention'
    assignmentDisplayName: 'assignment-vnet-naming-convention'
    assignmentName: 'assignment-vnet-policy'
    type: 'Microsoft.Resources/subscriptions/resourceGroups'
    policyDescription: 'Enforces Virtual network names to being with vnet-'
  }
}
