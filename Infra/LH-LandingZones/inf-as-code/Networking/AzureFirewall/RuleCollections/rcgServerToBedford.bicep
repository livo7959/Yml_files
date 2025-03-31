@description('Name of rule collection group')
param rcgName string = 'rcg-server-to-bedford-allow'

@description('Existing Firewall Policy Name')
param existingFwPolicyName string = 'policy-azfw-hub-eus-001'

resource fwPolicy 'Microsoft.Network/firewallPolicies@2022-07-01' existing = {
  name: existingFwPolicyName
}

resource rcg 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2024-01-01' = {
  name: rcgName
  parent: fwPolicy
  properties: {
    priority: 1600
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        priority: 100
        name: 'rc-net-server-to-bed-allow'
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'azdo-agent-to-bed-azdo-server'
            description: 'Allows AzureDevOps agents to Bedford AzDo servers'
              sourceAddresses: [
                '10.120.160.0/24'
              ]
              destinationAddresses: [
                '10.10.32.211'
                '10.10.32.155'
              ]
              ipProtocols: [
                'TCP'
              ]
              destinationPorts: [
                '443'
              ]
          }
        ]
      }
    ]
  }
}
