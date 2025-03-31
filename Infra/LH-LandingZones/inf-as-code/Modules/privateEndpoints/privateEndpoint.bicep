@description('Region of the private endpoint')
param location string = resourceGroup().location

@description('Name of the private endpoint')
param privateEndpointName string

@description('Private endpoint group IDs')
param privateEndpointGroupIds string

@description('Private endpoint virutal network name')
param virtualNetworkName string

@description('Private endpoint subnet name')
param subnetName string

@description('Resource ID of the resource to create the private endpoint for')
param privateEndpointTargetResourceId string

@description('Private DNS zone')
param privateDnsZoneName string

@description('Private DNS zone resource group name')
param privateDnsZoneResourceGroupName string

@description('Private Endpoint resource group name')
param privateEndpointResourceGroupName string

@description('Tag Values')
param tagValues object

// Declare variables

var privateEndpointNicName = 'nic-${privateEndpointName}'

resource vnet 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  name: virtualNetworkName
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-09-01' = {
  name: privateEndpointName
  location: location
  tags: tagValues
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: privateEndpointTargetResourceId
          groupIds: [
            privateEndpointGroupIds
          ]
        }
      }
    ]
    customNetworkInterfaceName: privateEndpointNicName
    subnet: {
      id: '${vnet.id}/subnets/${subnetName}'
    }
  }
}

module privateDnsZone 'privateDnsZone.bicep' = {
  name: privateDnsZoneName
  scope: resourceGroup(privateEndpointResourceGroupName)
  params: {
    privateDnsZoneName: privateDnsZoneName
    privateDnsZoneResourceGroupName: privateDnsZoneResourceGroupName
    privateEndpointName: privateEndpointName
  }
  dependsOn: [
    privateEndpoint
  ]
}
