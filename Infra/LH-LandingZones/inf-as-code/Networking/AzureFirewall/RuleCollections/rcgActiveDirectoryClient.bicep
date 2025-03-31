@description('Name of rule collection group')
param rcgName string = 'rcg-active-directory-client-allow'

@description('Existing Firewall Policy Name')
param existingFwPolicyName string = 'policy-azfw-hub-eus-001'

resource fwPolicy 'Microsoft.Network/firewallPolicies@2022-07-01' existing = {
  name: existingFwPolicyName
}

resource ipGroupAzDcs 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-azure-eus-domaincontrollers'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgAvdVnet 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-AzureVirtualDesktop-internal'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgVnetIaasSharedProd 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-vnet-iaas-shared-prod-eus-001'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgVnetIaasSharedDev 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-vnet-iaas-shared-dev-eus-001'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipGroupAdcs 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-adcs-servers'
  scope: resourceGroup('rg-ip-groups-hub-001')
}


resource rcg 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2022-11-01' = {
  name: rcgName
  parent: fwPolicy
  properties: {
    priority: 1450
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-net-adds-client-inbound-allow'
        priority: 110
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'active-directory-client-tcp-inbound-allow'
            description: 'Allows client to DC TCP ports for AD DS'
            sourceIpGroups: [
              ipgAvdVnet.id
              ipgVnetIaasSharedProd.id
              ipgVnetIaasSharedDev.id
            ]
            destinationIpGroups: [
              ipGroupAzDcs.id
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '389'
              '88'
              '53'
              '464'
              '135'
              '139'
              '636'
              '3268'
              '3269'
              '445'
              '49152-65535'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'active-directory-client-udp-inbound-allow'
            description: 'Allows client to DC UDP ports for AD DS'
            sourceIpGroups: [
              ipgAvdVnet.id
              ipgVnetIaasSharedProd.id
              ipgVnetIaasSharedDev.id
            ]
            destinationIpGroups: [
              ipGroupAzDcs.id
            ]
            ipProtocols: [
              'UDP'
            ]
            destinationPorts: [
              '123'
              '389'
              '88'
              '53'
              '464'
              '138'
              '137'
            ]
          }
          {
            name: 'active-directory-client-icmp-inbound-internal-allow'
            ruleType: 'NetworkRule'
            description: 'Allows ICMP inbound from internal systems'
            sourceIpGroups: [
              ipgAvdVnet.id
              ipgVnetIaasSharedProd.id
              ipgVnetIaasSharedDev.id
            ]
            destinationIpGroups: [
              ipGroupAzDcs.id
            ]
            ipProtocols: [
              'ICMP'
            ]
            destinationPorts: [
              '*'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'active-directory-certificate-services-client-allow'
            description: 'Allows client to Active Directorty Cetificate Services ADCS'
            sourceIpGroups: [
              ipgAvdVnet.id
              ipgVnetIaasSharedProd.id
              ipgVnetIaasSharedDev.id
            ]
            destinationIpGroups: [
              ipGroupAdcs.id
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '135'
              '49152-65535'
            ]
          }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-net-defender-for-identity-allow'
        priority: 120
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'defender-for-identity-outboud-internal-tcp-allow'
            description: 'Allows Defender for Identity Network Name Resolution'
            sourceIpGroups: [
              ipGroupAzDcs.id
            ]
            destinationIpGroups: [
              ipgAvdVnet.id
              ipgVnetIaasSharedDev.id
              ipgVnetIaasSharedProd.id
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '135'
              '3389'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'defender-for-identity-outboud-internal-udp-allow'
            description: 'Allows Defender for Identity Network Name Resolution'
            sourceIpGroups: [
              ipGroupAzDcs.id
            ]
            destinationIpGroups: [
              ipgAvdVnet.id
              ipgVnetIaasSharedDev.id
              ipgVnetIaasSharedProd.id
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '137'
            ]
          }
        ]
      }
    ]
  }
}
