targetScope = 'resourceGroup'

param localVnetName string = ''
param localVnetId string = ''

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

// this is relatively static so setting it as a default
param remoteVnetId string = '/subscriptions/da07f21c-d54b-41ca-9f74-9e124d6c2b99/resourceGroups/rg-net-hub-001/providers/Microsoft.Network/virtualNetworks/vnet-hub-eus-001'

var purpose_cleansed = toLower(take(replace(replace(purpose, ' ', ''), '-', ''),16))

// Local to Remote peering
module virtualNetwork_peering_local '../virtual-network/virtualNetworkPeerings/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-virtualNetworkPeering-local-001'
  params: {
    localVnetName: localVnetName
    remoteVirtualNetworkId: remoteVnetId
    name: 'peer-to-vnet-hub-${location}-001'
    allowForwardedTraffic: true
    allowGatewayTransit: true
    allowVirtualNetworkAccess: true
    doNotVerifyRemoteGateways: true
    useRemoteGateways: true
  }
}

// Remote to local peering (reverse)
module virtualNetwork_peering_remote '../virtual-network/virtualNetworkPeerings/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-virtualNetworkPeering-remote-001'
  scope: resourceGroup(split(remoteVnetId, '/')[2], split(remoteVnetId, '/')[4])
  params: {
    localVnetName: last(split(remoteVnetId, '/'))!
    remoteVirtualNetworkId: localVnetId
    name: 'peer-to-vnet-spoke-${purpose_cleansed}-${environment}-${vnetNameIter}'
    allowForwardedTraffic: true
    allowGatewayTransit: true
    allowVirtualNetworkAccess: true
    doNotVerifyRemoteGateways: true
    useRemoteGateways: false
  }
}

output vnetLocalPeeringName string = virtualNetwork_peering_local.outputs.name
output vnetRemotePeeringName string = virtualNetwork_peering_remote.outputs.name
