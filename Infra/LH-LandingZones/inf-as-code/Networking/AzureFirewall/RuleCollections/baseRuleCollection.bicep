targetScope = 'resourceGroup'

@description('Base Deny Rule Collection group name')
param rcgBaseDenyName string = 'rcg-base-deny'

@description('Global Allow Rule Collection group name')
param rcgBaseAllowName string = 'rcg-base-allow'

resource baseFirewallPolicy 'Microsoft.Network/firewallPolicies@2022-07-01' existing = {
  name: 'azfw-policy-base-eus-001'
}

resource rcgBaseDeny 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2022-07-01' = {
  name: rcgBaseDenyName
  parent: baseFirewallPolicy
  properties:{
    priority: 500
    ruleCollections:[
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-base-network-deny'
        priority: 100
        action: {
          type: 'Deny'
        }
      }

      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-base-application-deny'
        priority: 200
        action: {
          type: 'Deny'
        }
      }
        ]
      }
    }

    resource rcgBaseAllow 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2022-07-01' = {
      name: rcgBaseAllowName
      parent: baseFirewallPolicy
      properties:{
        priority: 600
        ruleCollections:[
          {
            ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
            name: 'rc-base-network-allow'
            priority: 100
            action: {
              type: 'Allow'
            }
            rules: [
              {
                name: 'base-udp-allow'
                ruleType: 'NetworkRule'
                description: 'UDP Rules for all'
                sourceAddresses: [
                  '*'
                ]
                destinationAddresses: [
                  '*.time.windows.com'
                ]
              }
            ]
          }

          {
            ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
            name: 'rc-base-application-allow'
            priority: 200
            action: {
              type: 'Allow'
            }
            rules: [
              {
                ruleType: 'ApplicationRule'
                name: 'fqdn-tags-https-outbound-allow'
                sourceAddresses: [
                  '*'
                ]
                fqdnTags: [
                  'WindowsUpdate'
                ]
                protocols: [
                  {
                    protocolType: 'Https'
                    port: 443
                  }
                ]
              }
            ]
          }
            ]
          }
        }

