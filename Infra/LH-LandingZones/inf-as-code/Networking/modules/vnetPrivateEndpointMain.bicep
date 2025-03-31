targetScope = 'resourceGroup'

@description('Name of virtual network')
param vnetName string

@description('Address space of the vnet, I.E 10.0.0.0/16')
param vnetAddressPrefix string

@description('Name of the subnet')
param snetName string

@description('Address space of the subnet, I.E 10.0.0.0/24')
param snetAddressPrefix string

param location string = resourceGroup().location

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

var nsgName = 'nsg-${snetName}'

resource vNet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
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
          privateEndpointNetworkPolicies: 'Enabled'
           }
        }
    ]
    virtualNetworkPeerings: [
      
    ]
    enableDdosProtection: false
  }
}

// Creates a network security group with the default rules
resource nsgSubnet 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: nsgName
  location: location
  tags: {
    Department: tagDepartment
    Environment: tagEnvironment
  }
}
