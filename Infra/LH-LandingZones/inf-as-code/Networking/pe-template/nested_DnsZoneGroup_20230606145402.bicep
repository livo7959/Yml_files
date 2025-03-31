param privateEndpointName string
param location string

@description('Private DNS zone')
param privateDnsZoneName string = 'privatelink.blob.core.windows.net'

@description('Private DNS zone resource group name')
param privateDnsZoneResourceGroupName string = 'rg-net-hub-001'

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateDnsZoneName
  scope: resourceGroup(privateDnsZoneResourceGroupName)
}
resource privateEndpointName_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-05-01' = {
  name: '${privateEndpointName}/default'
  location: location
  properties: {
    privateDnsZoneConfigs: [
      {
        name: privateDnsZoneName
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }
}
