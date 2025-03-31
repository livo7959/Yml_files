@description('Name of rule collection group')
param rcgName string = 'rcg-microsoft-global-allow'

@description('Existing Firewall Policy Name')
param existingFwPolicyName string = 'policy-azfw-hub-eus-001'

resource fwPolicy 'Microsoft.Network/firewallPolicies@2022-07-01' existing = {
  name: existingFwPolicyName
}

// Declare existing IP Groups
resource ipGroupDns 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-external-dns'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipGroupAzDcs 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-azure-eus-domaincontrollers'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource rcg 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2022-07-01' = {
  name: rcgName
  parent: fwPolicy
  properties: {
    priority: 1000
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-net-microsoft-outbound-external-allow'
        priority: 100
        action: {
          type: 'Allow'
        }
        rules: [
          {
            name: 'windows-time-udp-allow'
            ruleType: 'NetworkRule'
            description: 'Allow time.windows.com'
            sourceAddresses: [
              '*'
            ]
            destinationAddresses: [
              '168.61.215.74'
            ]
            ipProtocols: [
              'UDP'
            ]
            destinationPorts: [
              '123'
            ]
          }
          {
            name: 'kms-fqdn-tcp-1688'
            ruleType: 'NetworkRule'
            sourceAddresses: [
              '*'
            ]
            destinationFqdns: [
              'azkms.core.windows.net'
              'kms.core.windows.net'
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '1688'
            ]
          }
          {
            name: 'kms-ip-tcp-1688'
            ruleType: 'NetworkRule'
            sourceAddresses: [
              '*'
            ]
            destinationAddresses: [
              '20.118.99.224'
              '40.83.235.53'
              '23.102.135.246'
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '1688'
            ]
          }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-app-microsoft-outbound-external-allow'
        priority: 200
        action: {
          type: 'Allow'
        }
        rules: [
          {
            name: 'windows-update-outbound-external-allow'
            ruleType: 'ApplicationRule'
            description: 'Allows public Windows Update'
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
              {
                protocolType: 'Http'
                port: 80
              }
            ]
          }
          {
            name: 'defender-outbound-external-fqdn-https-allow'
            ruleType: 'ApplicationRule'
            description: 'Microsoft Defender for Endpoint'
            sourceAddresses: [
              '*'
            ]
            targetFqdns: [
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
              'vortex-win.data.microsoft.com'
              'settings-win.data.microsoft.com'
              '*.wdcp.microsoft.com'
              '*.wdcpalt.microsoft.com'
              '*.wd.microsoft.com'
              'ctldl.windows.com'
              '*.smartscreen-prod.microsoft.com'
              '*.smartscreen.microsoft.com'
              '*.checkappexec.microsoft.com'
              '*.urs.microsoft.com'
              '*.download.microsoft.com'
              '*.download.windowsupdate.com'
              'go.microsoft.com'
            ]
            protocols: [
              {
                port: 443
                protocolType: 'Https'
              }
            ]
          }
          {
            name: 'azure-monitor-outbound-external-https-allow'
            ruleType: 'ApplicationRule'
            description: 'Azure Monitor'
            sourceAddresses: [
              '*'
            ]
            targetFqdns: [
              'global.handler.control.monitor.azure.com'
              'eastus.handler.control.monitor.azure.com'
              '4858fbdb-07de-4a31-8bd0-2cfc6914b460.ods.opinsights.azure.com'
              'eastus.monitoring.azure.com'
              'management.azure.com'
            ]
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
            ]
          }
          {
            name: 'defender-outbound-external-https-url-allow'
            ruleType: 'ApplicationRule'
            description: 'Required Defender URLs'
            sourceAddresses: [
              '*'
            ]
            targetUrls: [
              'msdl.microsoft.com/download/symbols'
              'fe3cr.delivery.mp.microsoft.com/ClientWebService/client.asmx'
              'www.microsoft.com/security/encyclopedia/adlpackages.aspx'
              'definitionupdates.microsoft.com/download/DefinitionUpdates'
            ]
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
            ]
            terminateTLS: true
          }
          {
            name: 'defender-outbound-external-http-url-allow'
            ruleType: 'ApplicationRule'
            description: 'Defender HTTP Urls'
            sourceAddresses: [
              '*'
            ]
            targetUrls: [
              'crl.microsoft.com/pki/crl/*'
              'www.microsoft.com/pkiops/*'
              'www.microsoft.com/pki/certs'
              'ctldl.windowsupdate.com'
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
