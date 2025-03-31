@description('Region of the resource.')
param location string = resourceGroup().location

@description('Name of virtual network')
param vnetName string

@description('Address space of the vnet, I.E 10.0.0.0/16')
param vnetAddressPrefix string

@description('Name of the subnet')
param snetName string

@description('Address space of the subnet, I.E 10.0.0.0/24')
param snetAddressPrefix string

@sys.description('Department Tag')
param tagDepartment string = 'Infrastructure'

@sys.description('Environment tag')
@allowed([
  'Production'
  'Development'
  'UAT'
  'QA'
])
param tagEnvironment string

@description('Set to True to Disable BPG Route propagation')
param disableBgpRoutePropagation bool

var nsgName = 'nsg-${snetName}'
var routeTableName = 'rt-${snetName}'
var azfwInternalIpAddress = '10.120.0.68'

resource vNet 'Microsoft.Network/virtualNetworks@2022-09-01' = {
  name: vnetName
  location: location
  tags:{
    department: tagDepartment
    environment: tagEnvironment
    }
  properties: {
    addressSpace:{
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: snetName
        properties: {
          addressPrefix: snetAddressPrefix
          networkSecurityGroup:{
            id: nsgSubnet.id
          }
          routeTable: {
            id: routeTable.id
          }
          }
        }
    ]
    enableDdosProtection: false
  }
}

// Creates a network security group with the default rules
resource nsgSubnet 'Microsoft.Network/networkSecurityGroups@2022-09-01' = {
  name: nsgName
  location: location
  tags: {
    Department: tagDepartment
    Environment: tagEnvironment
  }
}

resource routeTable 'Microsoft.Network/routeTables@2022-09-01' = {
  name: routeTableName
  location: location
  tags: {
    Department: tagDepartment
    Environment: tagEnvironment
  }
  properties: {
    disableBgpRoutePropagation: disableBgpRoutePropagation
    routes: [
      {
        name: 'udr-azfw'
        properties: {
          nextHopType: 'VirtualAppliance'
          addressPrefix: '0.0.0.0/0'
          nextHopIpAddress: azfwInternalIpAddress
        }

      }
    ]
  }
}
