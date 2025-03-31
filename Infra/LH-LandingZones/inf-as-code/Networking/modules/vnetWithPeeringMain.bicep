@description('Name of the virtual network resource group')
param resourceGroupName string

@description('Subscription ID of the virtual network')
param subscriptionId string

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

@description('Resource ID of the Hub virtual network')
param hubVnetId string

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
var hubVirtualNetworkName = 'vnet-hub-eus-001'
var hubVnetSubcriptionId = 'da07f21c-d54b-41ca-9f74-9e124d6c2b99'
var hubVnetResourceGroupName = 'rg-net-hub-001'

resource hubVnet 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-09-01' existing = {
  name: hubVirtualNetworkName
  scope: resourceGroup(hubVnetSubcriptionId,hubVnetResourceGroupName)
}

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
        name: 'default-route'
        properties: {
          nextHopType: 'VirtualAppliance'
          addressPrefix: '0.0.0.0/0'
          nextHopIpAddress: azfwInternalIpAddress
        }

      }
    ]
  }
}

resource vnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-09-01' = {
  name: 'peer-to-${hubVirtualNetworkName}'
  parent: vNet
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: hubVnetId
    }
  }
}

module vnetPeeringHub 'vnetPeeringModule.bicep' = {
  name: 'peer-to-${vnetName}'
  scope: resourceGroup(hubVnetResourceGroupName)
  params: {
    peeringName: 'peer-to-${vnetName}'
    resourceGroupName: resourceGroupName
    subscriptionID: subscriptionId
    vNetName: vNet.name
    vNetNameHub: hubVirtualNetworkName
  }
}

output hubVnetId string = hubVnet.id
