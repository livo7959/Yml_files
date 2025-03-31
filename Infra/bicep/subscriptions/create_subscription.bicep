targetScope = 'tenant'

param subscription_name string
param management_group_id string
param subscription_workload string
param billing_account_name string
param billing_profile_name string
param invoice_section_name string

resource subscription_creation 'Microsoft.Subscription/aliases@2021-10-01' = {
  name: subscription_name
  scope: tenant()
  properties: {
    additionalProperties: {
      managementGroupId: management_group_id
    }
    displayName: subscription_name
    workload: subscription_workload
    billingScope: '/billingAccounts/${billing_account_name}/billingProfiles/${billing_profile_name}/invoiceSections/${invoice_section_name}'
  }
}
