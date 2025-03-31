targetScope = 'subscription'

param rgName string = 'rg-vnet-iaas-dev-eus-01'
param rgNameKV string = 'rg-akv-iaas-dev-eus-01'
param location string = deployment().location

resource devResGrpVnet 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: rgName
  location: location
}

resource devResGrpKeyVault 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: rgNameKV
  location: location
}

var sharedVars = loadYamlContent('./shared-vars.yml')

module nsgDefault '../../../0_Global_Library/infrastructure_templates/bicep/local-unpublished/networkSecurityGroup.bicep' = {
  scope: devResGrpVnet
  name: 'nsg-${uniqueString(deployment().name, location)}'
  params: {
    location: location
    usage: 'default'
    resourceNameIter: '01'
    securityRules: [
      // TODO: add these rules in
      {
        name: 'Specific'
        properties: {
          access: 'Allow'
          description: 'Tests specific IPs and ports'
          destinationAddressPrefix: '*'
          destinationPortRange: '8080'
          direction: 'Inbound'
          priority: 100
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      // {
      //   name: 'Ranges'
      //   properties: {
      //     access: 'Allow'
      //     description: 'Tests Ranges'
      //     destinationAddressPrefixes: [
      //       '10.2.0.0/16'
      //       '10.3.0.0/16'
      //     ]
      //     destinationPortRanges: [
      //       '90'
      //       '91'
      //     ]
      //     direction: 'Inbound'
      //     priority: 101
      //     protocol: '*'
      //     sourceAddressPrefixes: [
      //       '10.0.0.0/16'
      //       '10.1.0.0/16'
      //     ]
      //     sourcePortRanges: [
      //       '80'
      //       '81'
      //     ]
      //   }
      // }
      // {
      //   name: 'Port_8082'
      //   properties: {
      //     access: 'Allow'
      //     description: 'Allow inbound access on TCP 8082'
      //     destinationApplicationSecurityGroups: [
      //       {
      //         id: '<id>'
      //       }
      //     ]
      //     destinationPortRange: '8082'
      //     direction: 'Inbound'
      //     priority: 102
      //     protocol: '*'
      //     sourceApplicationSecurityGroups: [
      //       {
      //         id: '<id>'
      //       }
      //     ]
      //     sourcePortRange: '*'
      //   }
      // }
    ]
    tags: {}
  }
}

//module routeTable 'br:bicep/modules/network.route-table:1.0.0' = {
module routeTable '../../../0_Global_Library/infrastructure_templates/bicep/local-unpublished/routetable.bicep' = {
  scope: devResGrpVnet
  name: 'rt-iaas-dev-001'
  params: {
    name: 'rt-iaas-dev-001'
    location: location
    routes: [
      {
        name: 'default'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopIpAddress: '10.120.0.68'
          nextHopType: 'VirtualAppliance'
        }
      }
      {
        name: 'private-endpoint-vnet'
        properties: {
          addressPrefix: '10.120.16.0/22'
          nextHopType: 'VnetLocal'
        }
      }
    ]
  }
}

module devVnet '../../../0_Global_Library/infrastructure_templates/bicep/local-unpublished/vnet.V1.bicep' = {
  // scope: resourceGroup(devResGrpVnet.name)
  scope: devResGrpVnet
  name: 'devVnetDeploy'
  params: {
    location: location
    purpose: sharedVars.purpose
    environment: sharedVars.environment
    vnetNameIter: '01'
    vnetAddressSpace: [
      '10.120.128.0/24'
    ]
    subnets: [
      {
        name: 'snet-iaas-dev-001'
        addressPrefix: '10.120.128.0/26'
        // addressPrefixes: []
        // applicationGatewayIpConfigurations: []
        // delegations: []
        // ipAllocations: []
        // natGatewayId: ''
        networkSecurityGroupId: nsgDefault.outputs.resourceId
        // privateEndpointNetworkPolicies: null
        // privateLinkServiceNetworkPolicies: null
        routeTableId: routeTable.outputs.resourceId
        // serviceEndpoints: []
        // serviceEndpointPolicies: []
      }
      {
        name: 'snet-iaas-dev-002'
        addressPrefix: '10.120.128.64/26'
        // addressPrefixes: []
        // applicationGatewayIpConfigurations: []
        // delegations: []
        // ipAllocations: []
        // natGatewayId: null
        networkSecurityGroupId: nsgDefault.outputs.resourceId
        // privateEndpointNetworkPolicies: null
        // privateLinkServiceNetworkPolicies: null
        routeTableId: routeTable.outputs.resourceId
        // serviceEndpoints: []
        // serviceEndpointPolicies: []
      }
    ]
  }
}

module devVnetPeerings '../../../0_Global_Library/infrastructure_templates/bicep/local-unpublished/vnet-peering.bicep' = {
  scope: devResGrpVnet
  name: 'vnet-peering-${sharedVars.environment}'
  params: {
    localVnetName: devVnet.outputs.name
    localVnetId: devVnet.outputs.resourceId
    location: location
    environment: sharedVars.environment
    purpose: sharedVars.purpose
  }
}

module devKeyVault '../../../0_Global_Library/infrastructure_templates/bicep/local-unpublished/keyvault.bicep' = {
  scope: devResGrpKeyVault
  name: 'kv-${uniqueString(deployment().name, location)}'
  params: {
    vaultName: 'kv-iaas-dev-001'
    location: location
    skuName: 'standard'
    ipRules: []
    virtualNetworkRules: [
      {
        id: devVnet.outputs.subnetResourceIds[0]
      }
    ]
    keys: []
    secrets: []
  }
}

output nsg string = nsgDefault.outputs.name
output routetable string = routeTable.outputs.name
output vnet string = devVnet.outputs.name
output localPeering string = devVnetPeerings.outputs.vnetLocalPeeringName
output remotePeering string = devVnetPeerings.outputs.vnetLocalPeeringName
