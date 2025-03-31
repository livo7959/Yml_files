targetScope = 'subscription'
@allowed([
  'sbox'
  'dev'
  'qa'
  'uat'
  'prod'
  'shared'
])
param environment_name string
param management_groups array
param target_subscription_name string

module resource_group_mg './subscriptions/subscription_handler.bicep' = [for management_group in management_groups: {
  name: 'rg_setup_${management_group.name}'
  params: {
    environment_name: environment_name
    subscriptions: management_group.subscriptions
    target_subscription_name: target_subscription_name
  }
}]
