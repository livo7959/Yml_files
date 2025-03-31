targetScope = 'subscription'

param environment_name string
param subscriptions array
param target_subscription_name string

module resource_group_creations '../resource_group/resource_group_handler.bicep' = [for subscription in subscriptions: if (target_subscription_name == subscription.subscription_name) {
  name: 'create_rgs_for_${subscription.subscription_name}'
  params: {
    environment_name: environment_name
    resource_groups: subscription.resource_groups
  }
}]
