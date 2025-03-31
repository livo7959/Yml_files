targetScope = 'subscription'

param location string = deployment().location

resource devResGrpVnet 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'rg-${sharedVars.purpose}-${sharedVars.environment}-${sharedVars.locationShortName}'
  location: location
  tags: {
    environment: sharedVars.environment
  }
}

resource devResGrpKeyVault 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'rg-kv-${sharedVars.purpose}-${sharedVars.environment}-${sharedVars.locationShortName}'
  location: location
  tags: {
    environment: sharedVars.environment
  }
}

var sharedVars = loadYamlContent('./shared-vars.yml')
var securityRules = loadJsonContent('json/nsg-rules-dev.json').securityRules
var hubVnetId = '/subscriptions/da07f21c-d54b-41ca-9f74-9e124d6c2b99/resourceGroups/rg-net-hub-001/providers/Microsoft.Network/virtualNetworks/vnet-hub-eus-001'
var virtualMachines = loadJsonContent('json/virtualMachines.json').virtualMachines

module nsgDefault '../../../0_Global_Library/infrastructure_templates/bicep/local-unpublished/networkSecurityGroup.bicep' = {
  scope: devResGrpVnet
  name: 'nsg-${sharedVars.purpose}-${sharedVars.environment}-${sharedVars.locationShortName}'
  params: {
    location: location
    usage: sharedVars.purpose
    resourceNameIter: '001'
    securityRules: securityRules
    tags: {}
  }
}

//module routeTable 'br:bicep/modules/network.route-table:1.0.0' = {
module routeTable '../../../0_Global_Library/infrastructure_templates/bicep/local-unpublished/routetable.bicep' = {
  scope: devResGrpVnet
  name: 'rt-${sharedVars.purpose}-${sharedVars.environment}-${sharedVars.locationShortName}'
  params: {
    name: 'rt-${sharedVars.purpose}-${sharedVars.environment}-${sharedVars.locationShortName}'
    location: location
    routes: [
      {
        name: 'udr-default'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopIpAddress: sharedVars.azfwIp
          nextHopType: 'VirtualAppliance'
        }
      }
      {
        name: 'udr-private-endpoint-vnet'
        properties: {
          addressPrefix: '10.120.16.0/22'
          nextHopIpAddress: sharedVars.azfwIp
          nextHopType: 'VirtualAppliance'
        }
      }
    ]
  }
}

module devVnet '../../../0_Global_Library/infrastructure_templates/bicep/virtual-network/main.bicep' = {
  scope: devResGrpVnet
  name: 'vnet-${sharedVars.purpose}-${sharedVars.environment}-${sharedVars.locationShortName}'
  params: {
    name: 'vnet-${sharedVars.purpose}-${sharedVars.environment}-${sharedVars.locationShortName}'
    addressPrefixes: [
      '10.120.128.0/24'
    ]
    location: location
    lock: 'NotSpecified'
    dnsServers: [
      '10.120.24.8'
      '10.120.24.9'
    ]
    newOrExistingNSG: 'existing'
    networkSecurityGroupName: nsgDefault.name
    subnets: [
      {
        name: 'snet-${sharedVars.purpose}-${sharedVars.environment}-${sharedVars.locationShortName}-001'
        addressPrefix: '10.120.128.0/26'
      }
      {
        name: 'snet-${sharedVars.purpose}-${sharedVars.environment}-${sharedVars.locationShortName}-002'
        addressPrefix: '10.120.128.64/26'
      }
    ]
    virtualNetworkPeerings: [
      {
        remoteVirtualNetworkId: hubVnetId
        allowForwardedTraffic: true
        allowGatewayTransit: false
        allowVirtualNetworkAccess: true
        useRemoteGateways: false
        remotePeeringEnabled: true
        remotePeeringName: 'peer-to-vnet-${sharedVars.purpose}-${sharedVars.environment}-${sharedVars.locationShortName}'
        remotePeeringAllowVirtualNetworkAccess: true
        remotePeeringAllowForwardedTraffic: false
      }
    ]   
  }
}

module devKeyVault '../../../0_Global_Library/infrastructure_templates/bicep/local-unpublished/keyvault.bicep' = {
  scope: devResGrpKeyVault
  name: 'kv-${sharedVars.purpose}-${sharedVars.environment}-${sharedVars.locationShortName}'
  params: {
    vaultName: 'kv-${sharedVars.purpose}-${sharedVars.environment}-${sharedVars.locationShortName}'
    location: location
    skuName: 'standard'
    ipRules: [
      '66.97.189.250'
    ]
    virtualNetworkRules: []
    keys: []
    secrets: []
    publickNetworkAccess: 'enabled'
  }
}

output nsg string = nsgDefault.outputs.name
output routetable string = routeTable.outputs.name
output vnet string = devVnet.outputs.name
output keyvault string = devKeyVault.outputs.name
