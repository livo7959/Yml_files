param location string = resourceGroup().location

module vnet '../modules/vnetNoPeeringMain.bicep' = {
  name: 'vnet-avd-eus-001'
  params: {
    snetAddressPrefix: '10.120.32.0/24'
    snetName: 'snet-avd-eus-001'
    tagEnvironment: 'Production'
    vnetAddressPrefix: '10.120.32.0/21'
    vnetName: 'vnet-avd-eus-001'
    location: location
    tagDepartment: 'Infrastructure'
    disableBgpRoutePropagation: true
  }
}
