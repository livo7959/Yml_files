@description('Name of rule collection group')
param rcgName string = 'rcg-platform-as-a-service-allow'

@description('Existing Firewall Policy Name')
param existingFwPolicyName string = 'policy-azfw-hub-eus-001'

resource fwPolicy 'Microsoft.Network/firewallPolicies@2022-07-01' existing = {
  name: existingFwPolicyName
}

resource rcg 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2024-01-01' = {
  name: rcgName
  parent: fwPolicy
  properties: {
    priority: 1800
    ruleCollections: [
      // We must specify rules for everything documented here:
      // https://learn.microsoft.com/en-us/azure/container-apps/networking?tabs=workload-profiles-env%2Cazure-cli#configuring-udr-with-azure-firewall
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        priority: 100
        name: 'rc-app-container-apps-environments-allow'
        action: {
          type: 'Allow'
        }

        rules: [
          // TODO
        ]
      }
    ]
  }
}
