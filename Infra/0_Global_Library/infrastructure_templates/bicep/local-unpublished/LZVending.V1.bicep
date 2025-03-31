targetScope = 'managementGroup'

// reference: https://github.com/Azure/bicep-registry-modules/tree/main/modules/lz/sub-vending#example-3---subscription-creation--management-group-placement-and-create-virtual-network-and-peering-to-virtual-network

@description('Specifies the location for resources.')
param location string = 'eastus'
param purpose string = 'appPlaceholder'
@allowed([
  'dev'
  'qa'
  'prod'
])
param environment string = 'dev'

param billingscope string = '/providers/Microsoft.Billing/billingAccounts/500c2dab-e8af-5608-636f-2255ea5bff6f:75db6618-5564-4b1c-9a73-42085960f210_2019-05-31/billingProfiles/5MN2-ODQT-BG7-PGB/invoiceSections/2LWA-HHQH-PJA-PGB'
param subName string
param subTags object = {}
param vnetResGrpTags object = {}

@description('Specifies the subscription type, whether Production (default) or DevTest, which comes with reduced pricing on Microsoft software.')
@allowed([
  'DevTest'
  'Production'
])
param subWorkload string = 'Production'

param managementGroupId string = 'mg-lh-corp-dev'
param vnetAddressSpace array = ['10.3.0.0/24']
param hubVnetResourceId string = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rsg-uks-net-hub-001/providers/Microsoft.Network/virtualNetworks/vnet-uks-hub-001'

// @description('Optional. An Array of subnets to deploy to the Virtual Network. For guidance, refer to https://github.com/Azure/ResourceModules/tree/main/modules/network/virtual-network')
// param subnets array = []

// @maxLength(64)
// @description('Give the name of the default network security group to create for the LZ vnet')
// param nsgName string = ''
// param nsgSecurityRules array = []
// param nsgTags object = {}

// @maxLength(64)
// @description('Give the name of the default route table to use for the LZ vnet subnets')
// param routeTableName string = ''
// param routeTableRoutes array = []
// param routeTableTags object = {}


// module sub '../sub-vending-v1.4.2/main.bicep' = {
module sub 'br/public:lz/sub-vending:1.4.2' = {
  name: subName
  params: {
    subscriptionAliasEnabled: true
    subscriptionBillingScope: billingscope
    subscriptionAliasName: subName
    subscriptionDisplayName: subName
    subscriptionTags: subTags
    subscriptionWorkload: subWorkload
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: managementGroupId
    virtualNetworkEnabled: false
    virtualNetworkLocation: location
    virtualNetworkResourceGroupName: 'rg-${purpose}-${environment}-${location}-net-001'
    virtualNetworkResourceGroupTags: vnetResGrpTags
    virtualNetworkName: 'vnet-${purpose}-${environment}-${location}-001'
    virtualNetworkAddressSpace: vnetAddressSpace
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkPeeringEnabled: true
    hubNetworkResourceId: hubVnetResourceId
    // LH-custom params for custom module that we back-tracked on
    // subnets: subnets
    // nsgName: nsgName
    // nsgSecurityRules: nsgSecurityRules
    // nsgTags: nsgTags
    // routeTableName: routeTableName
    // routeTableRoutes: routeTableRoutes
    // routeTableTags: routeTableTags
  }
}

@sys.description('The Subscription ID that has been created or provided.')
output subscriptionId string = sub.outputs.subscriptionId

@sys.description('The Subscription Resource ID that has been created or provided.')
output subscriptionResourceId string = sub.outputs.subscriptionResourceId
