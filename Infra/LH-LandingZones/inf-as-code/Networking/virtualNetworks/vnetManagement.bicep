targetScope =  'resourceGroup'

param location string = resourceGroup().location

module vnet '../modules/vnetMain.bicep' = {
  name: 'vnet-management-eus-001'
  params: {
      vnetName: 'vnet-management-eus-001'
      vnetAddressPrefix: '10.120.16.128/25'
      snetName: 'snet-management-eus-001'
      snetAddressPrefix: '10.120.16.128/27'
      tagEnvironment: 'Production'
      tagDepartment: 'Infrastructure'
      location: location
  }
}
