targetScope =  'resourceGroup'

param location string = resourceGroup().location

module vnet '../modules/vnetMain.bicep' = {
  name: 'Test-vnet-inf-sandbox-eus-001'
  params: {
      vnetName: 'test-vnet-inf-sandbox-eus-001'
      vnetAddressPrefix: '10.136.0.0/24'
      snetName: 'test-snet-inf-sandbox-eus-001'
      snetAddressPrefix: '10.136.0.0/24'
      tagEnvironment: 'Development'
      tagDepartment: 'Infrastructure'
      location: location
  }
}
