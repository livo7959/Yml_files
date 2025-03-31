@description('Region of the private endpoint')
param location string = resourceGroup().location

@description('Array to deploy n number of private endpoints')
param privateEndpoints array

@description('Existing Virtual Network Name')
param virtualNetworkName string

@description('Virtual Network Resource Group')
param virtualNetworkResourceGroupName string

resource vnet 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  name: virtualNetworkName
  scope: resourceGroup(virtualNetworkResourceGroupName)
}

resource pe 'Microsoft.Network/privateEndpoints@2022-09-01' = [ for (privateEndpoint, index) in privateEndpoints: {
  name: 'pep-${privateEndpoint.name}'
  location: location
  tags: {
    environment: privateEndpoint.env
  }
  properties: {
    privateLinkServiceConnections: [
      {
        name: 'pep-${privateEndpoint.name}'
        properties: {
          privateLinkServiceId: privateEndpoint.privateEndpointTargetResourceId
          groupIds: [
            privateEndpoint.privateEndpointGroupIds
          ]
        }
      }
    ]
    customNetworkInterfaceName: 'nic-pep-${privateEndpoint.name}'
    subnet: {
      id: '${vnet.id}/subnets/${privateEndpoint.subnetName}' 
    }
  }
}]

module privateDnsZone 'privateDnsZone.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: pe[index].name
  scope: resourceGroup(privateEndpoint.privateDnsZoneResourceGroupName)
  params: {
    privateDnsZoneName: privateEndpoint.privateDnsZoneName
    privateDnsZoneResourceGroupName: privateEndpoint.privateDnsZoneResourceGroupName
    privateEndpointName: pe[index].name
  }
  dependsOn: [
    pe
  ]
}]
