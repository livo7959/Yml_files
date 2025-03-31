// ----------------------------------------
// Parameter declaration
@description('Environment for deployment')
@allowed([
  'prod'
  'dev'
  'uat'
  'qa'
])
param env string

@description('Azure region for deployment.')
param location string = resourceGroup().location

@description('A list of required and optional subnet propeties.')
param subnets array

@description('Virtual Network Address Range')
param addressPrefixes array

@description('Tag values to be applied to resources in this deployment')
param tagValues object

@description('Group name is created based on the product name and component being deployed')
param groupName string

@description('Short name for the deployment region')
param locationShortName string

@description('Custom DNS servers for Virtual Network')
param dnsServers array

@description('Set to True to Disable BPG Route propagation')
param disableBgpRoutePropagation bool

@description('Set to true to deploy a route table with Azure az bcFirewall User Defined Route')
param deployRouteTable bool


// ----------------------------------------
// Variable declaration
var vnetName = 'vnet-${groupName}-${env}-${locationShortName}-001'
var nsgSecurityRules = json(loadTextContent('parameters/nsg-rules.json')).securityRules
var nsgName = 'nsg-${groupName}-${env}-${locationShortName}'
var azfwInternalIpAddress = '10.120.0.68'
var rtName = 'rt-${groupName}-${env}-${locationShortName}'

var dnsServers_var = {
  dnsServers: array(dnsServers)
}


// ----------------------------------------
// Resource declaration
resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: nsgSecurityRules
  }
}

resource routeTable 'Microsoft.Network/routeTables@2022-11-01' = if (deployRouteTable) {
  name: rtName
  location: location
  tags: tagValues
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
      {
      name: 'udr-private-endpoint-vnet'
      properties: {
        nextHopType: 'VirtualAppliance'
        addressPrefix: '10.120.16.0/22'
        nextHopIpAddress: azfwInternalIpAddress
      }
      }
    ]
  }
}


resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: vnetName
  location: location
  tags: tagValues
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    dhcpOptions: !empty(dnsServers) ? dnsServers_var : null
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.subnetPrefix
        serviceEndpoints: subnet.?serviceEndpoints ?? []
        delegations: subnet.?delegation ?? []
        networkSecurityGroup: {
          id: networkSecurityGroup.id
        }
        routeTable: {
          id: routeTable.id
        }
        privateEndpointNetworkPolicies: subnet.?privateEndpointNetworkPolicies
        privateLinkServiceNetworkPolicies: subnet.?privateLinkServiceNetworkPolicies
      }
    }]
  }
}


output virtualNetworkId string = virtualNetwork.id
