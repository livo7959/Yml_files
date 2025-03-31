param location string
param privateEndpointName string
param privateLinkResource string
param targetSubResource array
param requestMessage string
param subnet string
param virtualNetworkId string
param virtualNetworkResourceGroup string
param subnetDeploymentName string

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  location: location
  name: privateEndpointName
  properties: {
    subnet: {
      id: subnet
    }
    customNetworkInterfaceName: 'nic-${privateEndpointName}'
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: privateLinkResource
          groupIds: targetSubResource
        }
      }
    ]
  }
  tags: {}
  dependsOn: []
}

module DnsZoneGroup_20230606145402 './nested_DnsZoneGroup_20230606145402.bicep' = {
  name: 'DnsZoneGroup-20230606145402'
  scope: resourceGroup('rg-private-endpoint-eus-001')
  params: {
    privateEndpointName: privateEndpointName
    location: location
  }
  dependsOn: [
    privateEndpoint
  ]
}
