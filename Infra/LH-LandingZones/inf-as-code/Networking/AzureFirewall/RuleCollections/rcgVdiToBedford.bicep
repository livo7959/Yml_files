@description('Name of rule collection group')
param rcgName string = 'rcg-vdi-to-bedford-allow'

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

resource ipgBedfordServerSubnets 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-bedford-server-subnets'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgBedfordDevMgmtServers 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-bedford-dev-mgmt-servers'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgBedfordSqlServers 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-bedford-dba-mgmt-servers'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgBedfordDevRdpServers 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-bed-dev-saas-icer-servers'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipGroupBedDCs 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-bed-domaincontrollers'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipGroupAzDcs 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-azure-eus-domaincontrollers'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipGroupADCS 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-adcs-servers'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipGroupBedFileServers 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-bed-file-servers'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipGroupAllscriptsFE 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-allscripts-front-end'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipGroupCloudPcSqlServers 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-cloudpc-bedsql-servers'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipGroupBedRemoteAppServers 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-bed-remote-app-servers'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource rcg 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2022-09-01' = {
  name: rcgName
  parent: fwPolicy
  properties: {
    priority: 1400
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-net-vdi-all-outbound-bedford-allow'
        priority: 110
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'vdi-all-to-bed-tcp-80-443-allow'
            description: 'Allows HTTP and HTTPS traffic to Bedford F5 and server subnets'
            sourceIpGroups: [
              ipgAvdVnet.id
              ipgCloudPcVnet.id
            ]
            destinationIpGroups: [
              ipgBedfordServerSubnets.id
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '80'
              '443'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'vdi-all-to-bed-adcs-tcp-allow'
            description: 'Allows AD Certificate Services'
            sourceIpGroups: [
              ipgAvdVnet.id
              ipgCloudPcVnet.id
            ]
            destinationIpGroups: [
              ipGroupADCS.id
            ]
            destinationPorts: [
              '135'
              '49152-65535'
            ]
            ipProtocols: [
              'TCP'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'vdi-all-to-bed-servers-icmp-allow'
            description: 'Allows ICMP to Bed server subnets'
            sourceIpGroups: [
              ipgAvdVnet.id
              ipgCloudPcVnet.id
            ]
            destinationIpGroups: [
              ipgBedfordServerSubnets.id
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
            name: 'vdi-all-to-bed-smb-allow'
            description: 'Allows SMB access to Bedford File servers'
            sourceIpGroups: [
              ipgAvdVnet.id
            ]
            destinationIpGroups: [
              ipGroupBedFileServers.id
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '445'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'vdi-all-allscripts-tcp-allow'
            description: 'Allows client connection to AllScripts'
            sourceIpGroups: [
              ipgAvdVnet.id
              ipgCloudPcVnet.id
            ]
            destinationIpGroups: [
              ipGroupAllscriptsFE.id
            ]
            destinationPorts: [
              '135'
              '445'
              '49152-65535'
            ]
            ipProtocols: [
              'TCP'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'vdi-all-touchchart-sql-allow'
            description: 'Allows client connection to touch chart'
            sourceIpGroups: [
              ipgAvdVnet.id
              ipgCloudPcVnet.id
            ]
            destinationAddresses: [
              '10.10.32.174'
            ]
            destinationPorts: [
              '135'
              '1433'
              '445'
              '49152-65535'
            ]
            ipProtocols: [
              'TCP'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'vdi-all-remote-app-servers-allow'
            description: 'Allows access to Bedford remote app servers'
            sourceIpGroups: [
              ipgAvdVnet.id
              ipgCloudPcVnet.id
            ]
            destinationIpGroups: [
              ipGroupBedRemoteAppServers.id
            ]
            destinationPorts: [
              '443'
              '3389'
            ]
            ipProtocols: [
              'TCP'
            ]
          }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-net-vdi-dev-outbound-bedford-allow'
        priority: 120
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'vdi-dev-kerberos-allow'
            description: 'Allows Cloud PCs to retrieve Kerberos tickets'
            sourceIpGroups: [
              ipgCloudPcVnet.id
            ]
            destinationIpGroups: [
              ipGroupAzDcs.id
              ipGroupBedDCs.id
            ]
            ipProtocols: [
              'TCP'
              'UDP'
            ]
            destinationPorts: [
              '389'
              '88'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'vdi-dev-to-bed-rdp-allow'
            description: 'Allows RDP access to Bed Dev management servers'
            sourceIpGroups: [
              ipgCloudPcVnet.id
            ]
            destinationIpGroups: [
              ipgBedfordDevMgmtServers.id
              ipgBedfordDevRdpServers.id
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
            name: 'vdi-dev-to-bed-sql-allow'
            description: 'Allows Dev CPC to Bedford SQL servers port 1433'
            sourceIpGroups: [
              ipgCloudPcVnet.id
            ]
            destinationIpGroups: [
              ipGroupCloudPcSqlServers.id
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
            name: 'vdi-dev-to-bed-rabbitmq-allow'
            description: 'Allows ports 15672 and 5672 to rabbit mq servers'
            sourceIpGroups: [
              ipgCloudPcVnet.id
            ]
            destinationAddresses: [
              '10.0.25.13'
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '15672'
              '5672'
            ]  
          }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-app-vdi-all-outbound-bedford-allow'
        priority: 210
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'vdi-all-to-bedford-http-allow'
            sourceIpGroups: [
              ipgAvdVnet.id
              ipgCloudPcVnet.id
            ]
            targetUrls: [
              '*.logixhealth.com'
              '*.corp.logixhealth.local'
              'logixhealth.com'
              '*.patientcarefeedback.com'
              'patientcarefeedback.com'
            ]
            protocols: [
              {
                 port: 80
                 protocolType: 'Http'
              }
              {
                port: 443
                protocolType: 'Https'
              }
            ]
            terminateTLS: true
          }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-app-vdi-dev-to-bedford-allow'
        priority: 220
        action:  {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'vdi-dev-to-bed-sql-allow'
            sourceIpGroups: [
              ipgCloudPcVnet.id
            ]
            targetFqdns: [
              'bedsqlpm.corp.logixhealth.local'
              'beddsql001.corp.logixhealth.local'
              'beddsqlrpt001.corp.logixhealth.local'
              'bedpsqlsi01.corp.logixhealth.local'
              'bedqsql001.corp.logixhealth.local'
              'bedsqlbk001.corp.logixhealth.local'
              'bedsqllc02.corp.logixhealth.local'
              'bedusql001.corp.logixhealth.local'
            ]
            protocols: [
              {
                protocolType: 'mssql'
                port: 1433
              }
            ]

          }
        ]
      }
    ]
  }
}

