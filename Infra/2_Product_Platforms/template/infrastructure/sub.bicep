targetScope = 'subscription'

param rgName string = 'rg-vnet-iaas-dev-eus-01'
param location string = deployment().location

resource devResGrpVnet 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: rgName
  location: location
}

var sharedVars = loadYamlContent('./shared-vars.yml')

// module devResGrpVnet '../../../0_Global_Library/infrastructure_templates/bicep/carml/v0.11.1/resources/resource-group/main.bicep' = {
//   name: 'placeholder'
//   params: {
//     name: rgName
//     location: location
//   }
// }

module devVnet '../../../0_Global_Library/infrastructure_templates/bicep/local-unpublished/vnet.V1.bicep' = {
  scope: resourceGroup(devResGrpVnet.name)
  name: 'devVnetDeploy'
  params: {
    location: location
    purpose: sharedVars.purpose
    environment: sharedVars.environment
    vnetNameIter: '01'
    vnetAddressSpace: [
      '10.120.128.0/24'
    ]
    // subnets: [
    //   {
    //     name: 'snet-iaas-dev-001'
    //     addressPrefix: '10.120.128.0/26'
    //     addressPrefixes: []
    //     applicationGatewayIpConfigurations: []
    //     delegations: []
    //     ipAllocations: []
    //     natGatewayId: null
    //     networkSecurityGroupId: null
    //     privateEndpointNetworkPolicies: null
    //     privateLinkServiceNetworkPolicies: null
    //     routeTableId: null
    //     serviceEndpoints: []
    //     serviceEndpointPolicies: []
    //   }
    // ]
    // nsgName: 'nsg-default-eus-001'
    // nsgSecurityRules: []
    // routeTableName: 'route-default-eus-001'
    // routeTableRoutes: []
  }
}
