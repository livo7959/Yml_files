@description('Name of rule collection group')
param rcgName string = 'rcg-private-endpoint-storage'

@description('Existing Firewall Policy Name')
param existingFwPolicyName string = 'policy-azfw-hub-eus-001'

resource fwPolicy 'Microsoft.Network/firewallPolicies@2022-07-01' existing = {
  name: existingFwPolicyName
}

resource ipgPeProdDataAllowed 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-bed-pe-prod-data-allowed'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgDevCloudPc 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-cloudpc-internal'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgPeHttpsSubnets 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-private-endpoint-https-subnets'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource rcgPrivateEndpoint 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2022-09-01' = {
  name: rcgName
  parent: fwPolicy
  properties: {
    priority: 1600
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-net-pe-prod-data-storage-inbound-allow'
        priority: 110
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'pe-prod-data-urls-sftp-allow'
            description: 'Allows tcp port 22 to sftp blob storage accounts'
            sourceIpGroups: [
              ipgDevCloudPc.id
              ipgPeProdDataAllowed.id
            ]
            destinationFqdns: [
              'lhdatalakestorageprod.blob.core.windows.net'
              'lhexternalsftpprod.blob.core.windows.net'
              'lhinfsftp001.blob.core.windows.net'
              'lhexternalsftpsbox.blob.core.windows.net'
              'lhexternalsftpdev.blob.core.windows.net'
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '22'
            ]
          }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-net-pe-azure-file-shares-inbound-allow'
        priority: 120
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'fslogix-azure-files-smb-inbound-allow'
            description: 'Allows SMB access to FSLogix Azure File Share private endpoint'
            sourceAddresses: [
              '10.10.32.0/23'
              '10.20.32.0/24'
              '10.120.32.0/21'
            ]
            destinationFqdns: [
              'lhprodvdifs.file.core.windows.net'
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
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-net-pe-internal-inbound-allow'
        priority: 130
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'private-endpoint-shared-https-allow'
            description: 'Allows HTTPS to private endpoint https subnets'
            sourceAddresses: [
              '*'
            ]
            destinationIpGroups: [
              ipgPeHttpsSubnets.id
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
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-app-pe-prod-data-inbound-allow'
        priority: 210
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            description: 'Allows HTTPS to required storage urls'
            name: 'prod-pe-data-urls-https-allow'
            sourceIpGroups: [
              ipgDevCloudPc.id
              ipgPeProdDataAllowed.id
            ]
            targetFqdns: [
              'lhdatalakestorageprod.blob.core.windows.net'
              'lhexternalsftpprod.blob.core.windows.net'
              'lhinfsftp001.blob.core.windows.net'
              '*.blob.core.windows.net'
              'lhprodvdifs.file.core.windows.net'
            ]
            protocols: [
              {
                 port: 443
                 protocolType: 'Https'
              }
            ]
            terminateTLS: false
          }
        ]
      }
    ]
  }
}
