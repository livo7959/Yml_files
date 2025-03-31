@description('Name of rule collection group')
param rcgName string = 'rcg-azure-sql-allow'

@description('Existing Firewall Policy Name')
param existingFwPolicyName string = 'policy-azfw-hub-eus-001'

resource fwPolicy 'Microsoft.Network/firewallPolicies@2022-07-01' existing = {
  name: existingFwPolicyName
}

resource ipgBedProdServerSubnets 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-bed-prod-server-subnets'
  scope: resourceGroup('rg-ip-groups-hub-001')
}
resource ipgAzureSqlIaasSubnets 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-az-prod-sql-iaas-subnets'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgBedProdSqlServers 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-bed-prod-sql-aag-servers'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgBedDevSqlServers 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-bed-dev-sql-aag-servers'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgTechClientSubnets 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-technology-client-subnets'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgDevAzureSqlIaasSubnets 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-vnet-iaas-shared-dev-eus-001'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgBedDevServerSubnets 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-bed-dev-server-subnets'
  scope: resourceGroup('rg-ip-groups-hub-001')
}


resource rcgSqlHybrid 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2022-11-01' = {
  name: rcgName
  parent: fwPolicy
  properties: {
    priority: 1700
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-net-sql-hybrid-allow'
        priority: 110
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'azure-prod-sql-hybrid-tcp-outbound-allow'
            description: 'Allows Azure SQL subnets to Bedford SQL server to support AAG'
            sourceIpGroups: [
              ipgAzureSqlIaasSubnets.id
            ]
            destinationIpGroups: [
              ipgBedProdSqlServers.id
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '1433'
              '1434'
              '2383'
              '3343'
              '5022'
              '135'
              '445'
              '139'
              '49152-65535'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'azure-prod-sql-hybrid-udp-outbound-allow'
            description: 'Allows Azure SQL subnets to Bedford SQL server to support AAG'
            sourceIpGroups: [
              ipgAzureSqlIaasSubnets.id
            ]
            destinationIpGroups: [
              ipgBedProdSqlServers.id
            ]
            ipProtocols: [
              'UDP'
            ]
            destinationPorts: [
              '1434'
              '2382'
              '3343'
              '137'
              '138'
              '49152-65535'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'azure-prod-sql-hybrid-tcp-inbound-allow'
            description: 'Allows Bed SQL to Azure SQL to support AAG'
            sourceIpGroups: [
              ipgBedProdSqlServers.id
            ]
            destinationIpGroups: [
              ipgAzureSqlIaasSubnets.id
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '1433'
              '1434'
              '2383'
              '3343'
              '5022'
              '135'
              '445'
              '139'
              '49152-65535'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'azure-prod-sql-hybrid-udp-inbound-allow'
            description: 'Allows Bed SQL to Azure SQL to support AAG'
            sourceIpGroups: [
              ipgBedProdSqlServers.id
            ]
            destinationIpGroups: [
              ipgAzureSqlIaasSubnets.id
            ]
            ipProtocols: [
              'UDP'
            ]
            destinationPorts: [
              '1434'
              '2382'
              '3343'
              '137'
              '138'
              '49152-65535'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'azure-dev-sql-hybrid-tcp-outbound-allow'
            description: 'Allows dev Azure SQL subnets to Bedford SQL server to support AAG'
            sourceIpGroups: [
              ipgDevAzureSqlIaasSubnets.id
            ]
            destinationIpGroups: [
              ipgBedDevSqlServers.id
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '1433'
              '1434'
              '2383'
              '3343'
              '5022'
              '135'
              '445'
              '139'
              '49152-65535'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'azure-dev-sql-hybrid-udp-outbound-allow'
            description: 'Allows Azure SQL subnets to Bedford SQL server to support AAG'
            sourceIpGroups: [
              ipgDevAzureSqlIaasSubnets.id
            ]
            destinationIpGroups: [
              ipgBedDevSqlServers.id
            ]
            ipProtocols: [
              'UDP'
            ]
            destinationPorts: [
              '1434'
              '2382'
              '3343'
              '137'
              '138'
              '49152-65535'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'azure-dev-sql-hybrid-tcp-inbound-allow'
            description: 'Allows Bed SQL to Azure SQL to support AAG'
            sourceIpGroups: [
              ipgBedDevSqlServers.id
            ]
            destinationIpGroups: [
              ipgDevAzureSqlIaasSubnets.id
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '1433'
              '1434'
              '2383'
              '3343'
              '5022'
              '135'
              '445'
              '139'
              '49152-65535'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'azure-dev-sql-hybrid-udp-inbound-allow'
            description: 'Allows Bed SQL to Azure SQL to support AAG'
            sourceIpGroups: [
              ipgBedDevSqlServers.id
            ]
            destinationIpGroups: [
              ipgDevAzureSqlIaasSubnets.id
            ]
            ipProtocols: [
              'UDP'
            ]
            destinationPorts: [
              '1434'
              '2382'
              '3343'
              '137'
              '138'
              '49152-65535'
            ]
          }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-net-azure-sql-client-allow'
        priority: 120
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'azure-prod-sql-client-tcp-inbound-allow'
            description: 'Allows required client connections to SQL Servers in Azure'
            sourceIpGroups: [
              ipgBedProdServerSubnets.id
              ipgTechClientSubnets.id
            ]
            destinationIpGroups: [
              ipgAzureSqlIaasSubnets.id
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '1433'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'azure-prod-sql-client-rdp-inbound-allow'
            description: 'Allows rdp connections from management servers'
            sourceIpGroups: [
              ipgBedProdServerSubnets.id
            ]
            destinationIpGroups: [
              ipgAzureSqlIaasSubnets.id
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '3389'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'azure-dev-sql-client-tcp-inbound-allow'
            description: 'Allows required client connections to dev SQL Servers in Azure'
            sourceIpGroups: [
              ipgTechClientSubnets.id
              ipgBedDevServerSubnets.id
              ipgBedProdServerSubnets.id
            ]
            destinationIpGroups: [
              ipgDevAzureSqlIaasSubnets.id
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '1433'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'azure-dev-sql-client-rdp-inbound-allow'
            description: 'Allows rdp connections from management servers'
            sourceIpGroups: [
              ipgBedProdServerSubnets.id
            ]
            destinationIpGroups: [
              ipgDevAzureSqlIaasSubnets.id
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '3389'
            ]
          }
        ]
      }
    ]
  }
}
