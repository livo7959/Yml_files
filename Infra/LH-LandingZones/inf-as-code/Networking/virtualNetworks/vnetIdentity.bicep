targetScope =  'resourceGroup'

param location string = resourceGroup().location

module vnet '../modules/vnetMain.bicep' = {
  name: 'vnet-identity-eus-001'
  params: {
      vnetName: 'vnet-identity-eus-001'
      vnetAddressPrefix: '10.120.16.0/25'
      snetName: 'snet-dc-eus-001'
      snetAddressPrefix: '10.120.16.0/27'
      tagEnvironment: 'Production'
      tagDepartment: 'Infrastructure'
      location: location
  }
}
