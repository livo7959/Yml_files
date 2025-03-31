// Note as of September 9th, 2024, there have been manual changes in the firewall (via the web GUI).
// Thus, this file should not be executed, since it would blow away changes. Keep this comment at
// the top of the file until we can confirm that it is up to date.

@description('Region of your Azure Firewall')
param location string = resourceGroup().location

@description('Azure Firewall Name')
param azfwName string = 'azfw-hub-eus-001'

@description('Azure Firewall policy name')
param azfwPolicyName string = 'policy-${azfwName}'

@description('Public IP Address Name')
param azfwPublicIPAddressName string = 'pip-${azfwName}'

@description('FW policy tier')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param azfwPolicyTier string = 'Premium'

@description('Enable DNS proxy, required for FQDN in network rules')
param dnsProxyEnable bool = true

@description('Threat Intel Mode')
@allowed([
  'Alert'
  'Deny'
])
param threatIntelMode string = 'Deny'

@description('Intrusion Detection Mode')
@allowed([
  'Alert'
  'Deny'
])
param idsMode string = 'Deny'

@description('Availability zone numbers e.g. 1,2,3.')
param azfwAvailabilityZones array = [
  '1'
  '2'
  '3'
]

var logAnalyticsWorkspaceID = '/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourcegroups/rg-lh-logging-001/providers/microsoft.operationalinsights/workspaces/lh-log-analytics'
var existingVnetName = 'vnet-hub-eus-001'

resource azfwVnet 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: existingVnetName
}

resource azfwSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing = {
  name: 'AzureFirewallSubnet'
  parent: azfwVnet
}

resource baseFwPolicy 'Microsoft.Network/firewallPolicies@2022-07-01' existing = {
  name: 'azfw-policy-base-eus-001'
}

resource azfwPublicIPAddress 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: azfwPublicIPAddressName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
  zones: azfwAvailabilityZones
}

resource azFirewallPolicy 'Microsoft.Network/firewallPolicies@2022-07-01' = {
  name: azfwPolicyName
  location: location
  properties: {
    threatIntelMode: threatIntelMode
    sku: {
      tier: azfwPolicyTier
    }
    dnsSettings: {
      enableProxy: dnsProxyEnable
    }
    intrusionDetection: {
      mode: idsMode
    }
    insights: {
      isEnabled: true
      logAnalyticsResources: {
        defaultWorkspaceId: {
          id: logAnalyticsWorkspaceID
        }
      }
    }
    basePolicy: {
      id: baseFwPolicy.id
    }
  }
}

resource azFirewall 'Microsoft.Network/azureFirewalls@2022-07-01' = {
  name: azfwName
  location: location
  properties: {
    firewallPolicy: azFirewallPolicy
    sku: {
      name: 'AZFW_VNet'
      tier: 'Premium'
    }
    ipConfigurations: [
      {
        properties: {
          publicIPAddress: {
            id: azfwPublicIPAddress.id
          }
          subnet: {
            id: azfwSubnet.id
          }
        }
      }
    ]
  }
  zones: azfwAvailabilityZones
}
