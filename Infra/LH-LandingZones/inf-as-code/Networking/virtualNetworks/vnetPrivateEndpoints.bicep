param location string = resourceGroup().location

module vnet '../modules/vnetPrivateEndpointMain.bicep' = {
  name: 'vnet-private-endpoint-eus-001'
  params: {
    snetAddressPrefix: '10.120.16.0/27'
    snetName: 'snet-corp-fileshares-eus-001'
    tagEnvironment: 'Production'
    vnetAddressPrefix: '10.120.16.0/23'
    vnetName: 'vnet-private-endpoint-eus-001'
    location: location
    tagDepartment: 'Infrastructure'
  }
}
