@description('Region for the firewall policy')
param location string = resourceGroup().location

@description('Name of firewall policy')
param fwPolicyName string = 'policy-azfw-base-eus-001'

@description('FW policy tier')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param fwPolicyTier string = 'Premium'

@description('Enable DNS poxy, required for FQDN in network rules')
param dnsProxyEnable bool = true

@description('Threat Intel Mode')
@allowed([
  'Alert'
  'Deny'
])
param threatIntelMode string = 'Alert'

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2022-07-01' = {
  name: fwPolicyName
  location: location
  properties: {
    sku: {
      tier: fwPolicyTier
    }
    dnsSettings: {
      enableProxy: dnsProxyEnable
    }
    threatIntelMode: threatIntelMode
  }
}

