@description('Name of rule collection group')
param rcgName string = 'rcg-azure-file-shares-inbound-allow'

@description('Existing Firewall Policy Name')
param existingFwPolicyName string = 'policy-azfw-hub-eus-001'

resource fwPolicy 'Microsoft.Network/firewallPolicies@2022-07-01' existing = {
  name: existingFwPolicyName
}

// Declare existing IP Groups
resource ipgAvdVnet 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-AzureVirtualDesktop-internal'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgCloudPcVnet 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-cloudpc-internal'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgCorpAzureFiles 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-corp-azurefs-pep-subnet'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgBedProdServers 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-bed-prod-server-subnets'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgBedInfClientSubnet 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-bed-inf-client-subnet'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource rcg 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2022-09-01' = {
  name: rcgName
  parent: fwPolicy
  properties: {
    priority: 2000
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-net-corp-azure-file-shares-inbound-allow'
        priority: 110
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            description: 'Allows SMB to the Azure Files Private Endpoint subnet'
            name: 'corp-azure-file-shares-pep-smb-allow'
            sourceIpGroups: [
              ipgBedInfClientSubnet.id
              ipgBedProdServers.id
            ]
            destinationIpGroups: [
              ipgCorpAzureFiles.id
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '445'
            ]
          }
        ]
      }
    ]

    }
}
