metadata overview ='wrapper for Bicep Public Registry/modules/network/virtual-network@1.1.3'

targetScope = 'resourceGroup'

// reference: https://github.com/Azure/bicep-registry-modules/tree/main/modules/lz/sub-vending#example-3---subscription-creation--management-group-placement-and-create-virtual-network-and-peering-to-virtual-network

@description('Specifies the location for resources. Defaults to the resource group\'s location.')
param location string = resourceGroup().location

@description('Specifies how the resource(s) will be used')
param purpose string = 'appPlaceholder'
@allowed([
  'dev'
  'qa'
  'prod'
])
param environment string

@description('Specifies the number iteration to append to the vnet name. Defaults to "01".')
param vnetNameIter string = '01'

@metadata({
  example: ['10.3.0.0/24']
})
param vnetAddressSpace array = []

type subnet = {
  name: string?
  addressPrefix: string?
  networkSecurityGroupId: string?
  routeTableId: string?
  natGatewayId: string?
  delegations: array?
  privateEndpointNetworkPolicies: ('Disabled'|'Enabled')?
  privateLinkServiceNetworkPolicies: ('Disabled'|'Enabled')?
  serviceEndpoints: array?
  serviceEndpointPolcies: array?
}

@description('Optional. An Array of subnet objects to deploy to the Virtual Network. For guidance, refer to https://github.com/Azure/ResourceModules/tree/main/modules/network/virtual-network')
param subnets subnet[] = []

@allowed([ 'new', 'existing', 'none' ])
@description('Create a new, use an existing, or provide no default NSG.')
param newOrExistingNSG string = 'none'

@description('Name of default NSG to use for subnets.')
param networkSecurityGroupName string = 'nsg-${uniqueString(resourceGroup().name, location)}'


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

// strip spaces and hyphens out of the purpose parameter value. Truncate to 16 characters in length to keep names short.
var purpose_cleansed = toLower(take(replace(replace(purpose, ' ', ''), '-', ''),16))

// this is relatively static so making it a hard-coded var
// var hubVnetId = '/subscriptions/da07f21c-d54b-41ca-9f74-9e124d6c2b99/resourceGroups/rg-net-hub-001/providers/Microsoft.Network/virtualNetworks/vnet-hub-eus-001'

// TODO: convert into a private module
// module vnet_spoke 'br/public:network/virtual-network:1.1.3' = {
module vnet_spoke '../virtual-network/main.bicep' = {
  name: 'vnet-spoke-${uniqueString(deployment().name, location)}'
  params: {
    name: 'vnet-spoke-${purpose_cleansed}-${environment}-${vnetNameIter}'
    location: location
    addressPrefixes: vnetAddressSpace
    subnets: subnets
    newOrExistingNSG: newOrExistingNSG
    networkSecurityGroupName: networkSecurityGroupName
    // virtualNetworkPeerings: [
    //   {
    //     // name: 'peer-to-vnet-hub-${location}-001'
    //     remoteVirtualNetworkId: hubVnetId
    //     allowForwardedTraffic: true
    //     allowGatewayTransit: true
    //     allowVirtualNetworkAccess: true
    //     useRemoteGateways: true // updates remote gateway's route to add this network
    //     remotePeeringEnabled: true
    //     remotePeeringName: 'peer-to-vnet-spoke-${purpose_cleansed}-${environment}-${vnetNameIter}'
    //     remotePeeringAllowVirtualNetworkAccess: true
    //     remotePeeringAllowForwardedTraffic: true
    //   }
    // ]
  }
}

// resource localVnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-01-01' existing = {
//   name: 
// }


@description('The resource group the virtual network was deployed into')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the virtual network')
output resourceId string = vnet_spoke.outputs.resourceId

@description('The name of the virtual network')
output name string = vnet_spoke.outputs.name

@description('The names of the deployed subnets')
output subnetNames array = [for subnet in subnets: subnet.name]

@description('The resource IDs of the deployed subnets')
output subnetResourceIds array = [for subnet in subnets: az.resourceId('Microsoft.Network/virtualNetworks/subnets', vnet_spoke.outputs.name, subnet.name)]
