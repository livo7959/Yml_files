param subscriptionID string
param resourceGroupName string
param vNetName string
param vNetNameHub string
param peeringName string

resource vnetHub 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  name: vNetNameHub
}

resource vNet 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  name: vNetName
  scope: resourceGroup(subscriptionID,resourceGroupName)
}

resource VNETPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-09-01' = {
  name: peeringName
  parent: vnetHub
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vNet.id
    }
  }
}
