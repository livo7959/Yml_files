/* This bicep file container the required firewall rules for domain controllers running in azure
    It allows for outbound access to support, Defender for Identity, Defender for Servers, Azure Monitor,
    Azure AD Connect Health sync for ADDS, Public DNS.

    Outbound internal access for DC to DC communication in Bedford
    Inbound internal access for client/server to DC traffic

   per doc https://www.office.com (This endpoint is used only for discovery purposes during registration.)
*/
@description('Name of rule collection group')
param rcgName string = 'rcg-identity-allow'

@description('Existing Firewall Policy Name')
param existingFwPolicyName string = 'policy-azfw-hub-eus-001'

resource fwPolicy 'Microsoft.Network/firewallPolicies@2022-07-01' existing = {
  name: existingFwPolicyName
}

// Declare existing IP Groups
resource ipGroupExternalDns 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-external-dns'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipGroupInternalDns 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-internal-dns'
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

resource ipGroupAdcs 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-adcs-servers'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgObSubnet 'Microsoft.Network/ipGroups@2022-09-01' existing = {
  name: 'ipg-dnsr-outbound-subnet-eus'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgBedDcMgmtServers 'Microsoft.Network/ipGroups@2022-09-01' existing = {
  name: 'ipg-bed-dc-mgmt-servers'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgAvdVnet 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-AzureVirtualDesktop-internal'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource rcg 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2022-07-01' = {
  name: rcgName
  parent: fwPolicy
  properties: {
    priority: 1500
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-net-identity-outbound-external-allow'
        priority: 100
        action: {
          type: 'Allow'
        }
        rules: [
          {
            name: 'identity-outbound-dns-allow'
            ruleType: 'NetworkRule'
            description: 'Allows Public, Azure and internal DNS forwarding'
            sourceIpGroups: [
              ipGroupAzDcs.id
            ]
            destinationIpGroups: [
              ipGroupExternalDns.id
              ipGroupInternalDns.id
            ]
            destinationPorts: [
              '53'
            ]
            ipProtocols: [
              'TCP'
              'UDP'
            ]
          }
          {
            name: 'identity-icmp-outbound-allow'
            ruleType: 'NetworkRule'
            description: 'Allows ICMP Outbound'
            sourceIpGroups: [
              ipGroupAzDcs.id
            ]
            destinationAddresses: [
              '*'
            ]
            ipProtocols: [
              'ICMP'
            ]
            destinationPorts: [
              '*'
            ]
          }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-net-identity-inbound-internal-allow'
        priority: 120
        action: {
          type: 'Allow'
        }
        rules: [
          {
            name: 'identity-dns-inbound-internal-allow'
            ruleType: 'NetworkRule'
            description: 'Allows Required TCP-UDP Ports for DNS Only'
            sourceIpGroups: [
              ipgObSubnet.id
              ipgBedDcMgmtServers.id
              ipgAvdVnet.id
            ]
            destinationIpGroups: [
              ipGroupAzDcs.id
            ]
            ipProtocols: [
              'TCP'
              'UDP'
            ]
            destinationPorts: [
              '53'
            ]
            }
          {
            name: 'identity-adds-dc-to-dc-tcp-bidirectional-allow'
            ruleType: 'NetworkRule'
            description: 'Allows Required DC to DC TCP Ports for AD DS'
            sourceIpGroups: [
              ipGroupBedDCs.id
              ipGroupAzDcs.id
            ]
            destinationIpGroups: [
              ipGroupAzDcs.id
              ipGroupBedDCs.id
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '389'
              '53'
              '88'
              '464'
              '135'
              '139'
              '636'
              '3389'
              '3268'
              '3269'
              '445'
              '49152-65535'
            ]
            }
            {
              name: 'identity-adds-dc-to-dc-udp-bidirectional-allow'
              ruleType: 'NetworkRule'
              description: 'Allows Required UDP Ports for AD DS'
              sourceIpGroups: [
                ipGroupBedDCs.id
                ipGroupAzDcs.id
              ]
              destinationIpGroups: [
                ipGroupAzDcs.id
                ipGroupBedDCs.id
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
                name: 'identity-adds-client-tcp-bidirectional-allow'
                ruleType: 'NetworkRule'
                description: 'Allows Required TCP Ports for AD DS'
                sourceIpGroups: [
                    ipGroupAzDcs.id
                    ipGroupAdcs.id
                    ipgAvdVnet.id
                    ipgBedDcMgmtServers.id
                ]
                destinationIpGroups: [
                    ipGroupAzDcs.id
                    ipGroupAdcs.id
                    ipgAvdVnet.id
                    ipgBedDcMgmtServers.id
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
                  name: 'identity-adds-client-udp-bidirectional-allow'
                  ruleType: 'NetworkRule'
                  description: 'Allows Required UDP Ports for AD DS'
                  sourceIpGroups: [
                    ipGroupAzDcs.id
                    ipGroupAdcs.id
                    ipgAvdVnet.id
                    ipgBedDcMgmtServers.id
                  ]
                  destinationIpGroups: [
                    ipGroupAzDcs.id
                    ipGroupAdcs.id
                    ipgAvdVnet.id
                    ipgBedDcMgmtServers.id
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
                name: 'identity-rdp-inbound-allow'
                ruleType: 'NetworkRule'
                description: 'Bedford Servers allowed to RDP to Azure DCs'
                sourceIpGroups: [
                  ipgBedDcMgmtServers.id
                  ipGroupBedDCs.id
                ]
                destinationIpGroups: [
                  ipGroupAzDcs.id
                ]
                ipProtocols: [
                  'TCP'
                ]
                destinationPorts: [
                  '3389'
                ]
              }
              {
                name: 'identity-icmp-inbound-internal-allow'
                ruleType: 'NetworkRule'
                description: 'Allows ICMP inbound from internal systems'
                sourceIpGroups: [
                  ipGroupAdcs.id
                  ipgBedDcMgmtServers.id
                  ipGroupBedDCs.id
                  ipgAvdVnet.id
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
                name: 'identity-outbound-bed-eid-pp-servers'
                ruleType: 'NetworkRule'
                description: 'Azure DCs to Bed Entra ID Password Protection proxy servers'
                sourceIpGroups: [
                  ipGroupAzDcs.id
                ]
                destinationAddresses: [
                  '10.10.32.72'
                ]
                ipProtocols: [
                  'TCP'
                ]
                destinationPorts: [
                  '135'
                  '49153'
                ]
              }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-app-identity-outbound-external-allow'
        priority: 200
        action: {
          type: 'Allow'
        }
        rules: [
          {
            name: 'identity-defender-outbound-https-allow'
            ruleType: 'ApplicationRule'
            description: 'Defender for Identity, Microsoft Defender for Endpoint'
            sourceIpGroups: [
              ipGroupAzDcs.id
            ]
            targetFqdns: [
              '*.atp.azure.com'
              'events.data.microsoft.com'
              '*.notify.windows.com'
              '*.wns.windows.com'
              'login.microsoftonline.com'
              'login.live.com'
              'settings-win.data.microsoft.com'
              'enterpriseregistration.windows.net'
              '*.dm.microsoft.com'
              '*.securitycenter.windows.com'
              'unitedstates.x.cp.wd.microsoft.com'
              'us.vortex-win.data.microsoft.com'
              'us-v20.events.data.microsoft.com'
              'winatp-gw-cus.microsoft.com'
              'winatp-gw-eus.microsoft.com'
              'winatp-gw-cus3.microsoft.com'
              'winatp-gw-eus3.microsoft.com'
              'automatedirstrprdcus.blob.core.windows.net'
              'automatedirstrprdeus.blob.core.windows.net'
              'automatedirstrprdcus3.blob.core.windows.net'
              'automatedirstrprdeus3.blob.core.windows.net'
              'ussus1eastprod.blob.core.windows.net'
              'ussus2eastprod.blob.core.windows.net'
              'ussus3eastprod.blob.core.windows.net'
              'ussus4eastprod.blob.core.windows.net'
              'wsus1eastprod.blob.core.windows.net'
              'wsus2eastprod.blob.core.windows.net'
              'ussus1westprod.blob.core.windows.net'
              'ussus2westprod.blob.core.windows.net'
              'ussus3westprod.blob.core.windows.net'
              'ussus4westprod.blob.core.windows.net'
              'wsus1westprod.blob.core.windows.net'
              'wsus2westprod.blob.core.windows.net'
            ]
            protocols: [
              {
                port: 443
                protocolType: 'Https'
              }
            ]
          }
          {
            name: 'identity-monitoring-outbound-https-allow'
            ruleType: 'ApplicationRule'
            description: 'Azure Monitor and AAD Connect Health for AD DS required URLs'
            sourceIpGroups: [
              ipGroupAzDcs.id
            ]
            targetFqdns: [
              'global.handler.control.monitor.azure.com'
              'eastus.handler.control.monitor.azure.com'
              '4858fbdb-07de-4a31-8bd0-2cfc6914b460.ods.opinsights.azure.com'
              'eastus.monitoring.azure.com'
              'management.azure.com'
              '*.blob.core.windows.net'
              '*.aadconnecthealth.azure.com'
              '*.servicebus.windows.net'
              '*.adhybridhealth.azure.com'
              'policykeyservice.dc.ad.msft.net'
              'login.windows.net'
              'login.microsoftonline.com'
              'secure.aadcdn.microsoftonline-p.com'
              'aadcdn.msftauth.net'
              'aadcdn.msauth.net'
              'www.office.com'
            ]
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
            ]
          }
          {
            name: 'identity-outbound-external-http-fqdn-allow'
            ruleType: 'ApplicationRule'
            description: 'Cert verify URLs'
            sourceIpGroups: [
              ipGroupAzDcs.id
            ]
            targetUrls: [
              'mscrl.microsoft.com'
              '*.verisign.com'
              '*.entrust.net'
              '*.crl3.digicert.com'
              '*.crl4.digicert.com'
              '*.ocsp.digicert.com'
              '*.www.d-trust.net'
              '*.root-c3-ca2-2009.ocsp.d-trust.net'
              '*.crl.microsoft.com'
              '*.oneocsp.microsoft.com'
              '*.ocsp.msocsp.com'
            ]
            protocols: [
              {
                protocolType: 'Http'
                port: 80
              }
            ]
          }
          {
            name: 'identity-outbound-external-http-url-allow'
            ruleType: 'ApplicationRule'
            description: 'Defender HTTP Urls'
            sourceIpGroups: [
              ipGroupAzDcs.id
            ]
            targetUrls: [
              'crl.microsoft.com/pki/crl/*'
              'www.microsoft.com/pkiops/*'
            ]
            protocols: [
            {
              protocolType: 'Http'
              port: 80
            }
            ]
          }
        ]
      }
    ]
  }
}
