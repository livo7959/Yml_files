targetScope = 'tenant'

@description('Name of Management Group (id)')
param mg_name string

@description('Display name of management group')
param mg_display_name string

@description('Parent of management group')
param mg_parent_name string

param subscriptions array

resource mg 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'mg-${mg_name}'
  scope: tenant()
  properties: {
    displayName: mg_display_name
    details: {
      parent: {
        id: resourceId('Microsoft.Management/managementGroups', mg_parent_name)
      }
    }
  }
}

output mg_id string = mg.id

// TODO do not hard code billing account info
module subscription_creations '../subscriptions/create_subscription.bicep' = [for subscription in subscriptions: {
  name: 'subscription_creation_${subscription.subscription_name}'
  scope: tenant()
  params: {
    subscription_name: subscription.subscription_name
    management_group_id: mg.id
    subscription_workload: subscription.workload_type
    billing_account_name: subscription.billing_account_name
    billing_profile_name: subscription.billing_profile_name
    invoice_section_name: subscription.invoice_section_name
  }
}]
