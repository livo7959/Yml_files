targetScope = 'managementGroup'

@description('Provide a name for the alias. This name will also be the display name of the subscription.')
param subscriptionAliasName string

@description('Provide the full resource ID of billing scope to use for subscription creation.')
param billingScope string

@description('Workload type of subscription, enter DevTest or Production')
@allowed([
  'DevTest'
  'Production'
])
param workloadType string = 'Production'

resource subscriptionAlias 'Microsoft.Subscription/aliases@2021-10-01' = {
  scope: tenant()
  name: subscriptionAliasName
  properties: {
    workload: workloadType
    displayName: subscriptionAliasName
    billingScope: billingScope
  }
}
