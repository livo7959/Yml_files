@description('Optional. The Name of Vnet Peering resource. If not provided, default value will be localVnetName-remoteVnetName')
param name string = 'peer-to-${last(split(remoteVirtualNetworkId, '/'))}'

@description('Required. The Name of the Virtual Network to add the peering to.')
param localVnetName string

@description('Required. The Resource ID of the VNet that is this Local VNet is being peered to. Should be in the format of a Resource ID')
param remoteVirtualNetworkId string

@description('Optional. Whether the forwarded traffic from the VMs in the local virtual network will be allowed/disallowed in remote virtual network. Default is true')
param allowForwardedTraffic bool = true

@description('Optional. If gateway links can be used in remote virtual networking to link to this virtual network. Default is false')
param allowGatewayTransit bool = false

@description('Optional. Whether the VMs in the local virtual network space would be able to access the VMs in remote virtual network space. Default is true')
param allowVirtualNetworkAccess bool = true

@description('Optional. If we need to verify the provisioning state of the remote gateway. Default is true')
param doNotVerifyRemoteGateways bool = true

@description('Optional. If remote gateways can be used on this virtual network. If the flag is set to true, and allowGatewayTransit on remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. Default is false')
param useRemoteGateways bool = false

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: localVnetName
}

resource virtualNetworkPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-01-01' = {
  name: name
  parent: virtualNetwork
  properties: {
    allowForwardedTraffic: allowForwardedTraffic
    allowGatewayTransit: allowGatewayTransit
    allowVirtualNetworkAccess: allowVirtualNetworkAccess
    doNotVerifyRemoteGateways: doNotVerifyRemoteGateways
    useRemoteGateways: useRemoteGateways
    remoteVirtualNetwork: {
      id: remoteVirtualNetworkId
    }
  }
}

@description('The resource group the virtual network peering was deployed into')
output resourceGroupName string = resourceGroup().name

@description('The name of the virtual network peering')
output name string = virtualNetworkPeering.name

@description('The resource ID of the virtual network peering')
output resourceId string = virtualNetworkPeering.id
