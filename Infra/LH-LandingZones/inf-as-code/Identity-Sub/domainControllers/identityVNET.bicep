param location string = resourceGroup().location

param vnetName string = 'vnet-identity-eus-001'

param snetName string = 'snet-dc-eus-001'

param snetAddressPrefix string = '10.120.24.0/27'

param nsgName string = 'nsg-${snetName}'

param rtName string = 'rt-${snetName}'

var nextHopIpAddress = '10.120.0.68'

resource vNet 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: vnetName
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: nsgName
  location: location
}

resource routeTable 'Microsoft.Network/routeTables@2022-07-01' = {
  name: rtName
  location: location
  properties: {
    disableBgpRoutePropagation: true
    routes: [
      {
        name: 'azfwRoute'
        properties: {
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: nextHopIpAddress
          addressPrefix: '0.0.0.0/0' 
        }
      }
    ]
  }
}

resource snet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: snetName
  parent: vNet
  properties: {
    addressPrefix: snetAddressPrefix
    routeTable: {
      id: routeTable.id
    }
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}

