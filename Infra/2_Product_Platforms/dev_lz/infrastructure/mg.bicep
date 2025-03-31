targetScope = 'managementGroup'

var sharedVars = loadYamlContent('./shared-vars.yml')

module devLz '../../../0_Global_Library/infrastructure_templates/bicep/local-unpublished/LZVending.V1.bicep' = {
  name: 'devLzDeploy'
  params: {
    billingscope: '/providers/Microsoft.Billing/billingAccounts/500c2dab-e8af-5608-636f-2255ea5bff6f:75db6618-5564-4b1c-9a73-42085960f210_2019-05-31/billingProfiles/5MN2-ODQT-BG7-PGB/invoiceSections/2LWA-HHQH-PJA-PGB'
    hubVnetResourceId: '/subscriptions/da07f21c-d54b-41ca-9f74-9e124d6c2b99/resourceGroups/rg-net-hub-001/providers/Microsoft.Network/virtualNetworks/vnet-hub-eus-001'
    purpose: sharedVars.purpose
    environment: sharedVars.environment
    subName: 'LH-Corp-Dev-002'
    subTags: {
      created_by: 'IaC repo pipeline'
      created_date: '20231012'
      environment: 'dev'
    }
    vnetResGrpTags: {
      created_by: 'IaC repo pipeline'
      created_date: '20231012'
      environment: 'dev'
    }
    subWorkload: 'DevTest'
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

output subscriptionId string = devLz.outputs.subscriptionId
