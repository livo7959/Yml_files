@description('Region of the route table.')
param location string = resourceGroup().location

@description('Route table name')
param rtbName string = 'rt-iaas-shared-prod-eus-001'

@description('Set to True to Disable BPG Route propagation')
param disableBgpRoutePropagation bool = false

var azfwInternalIpAddress = '10.120.0.68'

resource rtb 'Microsoft.Network/routeTables@2022-09-01' = {
  name: rtbName
  location: location
  properties: {
    disableBgpRoutePropagation: disableBgpRoutePropagation
    routes: [
      {
        name: 'udr-azfw'
        properties: {
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: azfwInternalIpAddress
          addressPrefix: '0.0.0.0/0'
        }
      }
    ]
  }
}
