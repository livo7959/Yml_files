@description('Name of rule collection group')
param rcgName string = 'rcg-azure-vdi-allow'

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

resource rcg 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2022-07-01' = {
  name: rcgName
  parent: fwPolicy
  properties: {
    priority: 1200
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-net-avd-outbound-external-allow'
        priority: 110
        action: {
          type: 'Allow'
        }
        rules: [
          {
            name: 'avd-net-fqdn-tcp-443-allow'
            ruleType: 'NetworkRule'
            sourceIpGroups: [
              ipgAvdVnet.id
              ipgCloudPcVnet.id
            ]
            destinationFqdns: [
              'login.microsoftonline.com'
              'mrsglobalsteus2prod.blob.core.windows.net'
              'wvdportalstorageblob.blob.core.windows.net'
              'login.windows.net'
              'www.msftconnecttest.com'
              'gcs.prod.monitoring.core.windows.net'
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '443'
            ]
          }
          {
            name: 'avd-net-fqdn-tcp-80-allow'
            ruleType: 'NetworkRule'
            sourceIpGroups: [
              ipgAvdVnet.id
              ipgCloudPcVnet.id
            ]
            destinationFqdns: [
              'oneocsp.microsoft.com'
              'www.microsoft.com'
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '80'
            ]
          }
          {
            name: 'avd-serviceTag-tcp-443-allow'
            ruleType: 'NetworkRule'
            sourceIpGroups: [
              ipgAvdVnet.id
              ipgCloudPcVnet.id
            ]
            destinationAddresses: [
              'WindowsVirtualDesktop'
              'AzureFrontDoor.Frontend'
              'AzureMonitor'
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '443'
            ]
          }
          {
            name: 'avd-kms-fqdn-tcp-1688-allow'
            ruleType: 'NetworkRule'
            sourceIpGroups: [
              ipgAvdVnet.id
              ipgCloudPcVnet.id
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
            name: 'avd-monitoring-ips-tcp-80-allow'
            ruleType: 'NetworkRule'
            description: 'For session host monitoring'
            sourceIpGroups: [
              ipgAvdVnet.id
              ipgCloudPcVnet.id
            ]
            destinationAddresses: [
              '169.254.169.254'
              '168.63.129.16'
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '80'
            ]
          }
          {
            name: 'avd-rdp-shortpath-server-endpoint-allow'
            ruleType: 'NetworkRule'
            description: 'Enables AVD session hosts to use RDP Shortpath'
            sourceIpGroups: [
              ipgAvdVnet.id
            ]
            destinationAddresses: [
              '*'
            ]
            ipProtocols: [
              'UDP'
            ]
            destinationPorts: [
              '49152-65535'
            ]
          }
          {
            name: 'avd-rdp-shortpath-stun-turn-udp-allow'
            ruleType: 'NetworkRule'
            description: 'Enables AVD session hosts to use RDP Shortpath'
            sourceIpGroups: [
              ipgAvdVnet.id
            ]
            destinationAddresses: [
              '20.202.0.0/16'
            ]
            ipProtocols: [
              'UDP'
            ]
            destinationPorts: [
              '3478'
            ]
          }
          {
            name: 'avd-rdp-shortpath-stun-turn-tcp-allow'
            ruleType: 'NetworkRule'
            description: 'Enables AVD session hosts to use RDP Shortpath'
            sourceIpGroups: [
              ipgAvdVnet.id
            ]
            destinationAddresses: [
              '20.202.0.0/16'
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
        name: 'rc-net-w365-cloudpc-outbound-external-allow'
        priority: 120
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'w365-cloudpc-fqdn-tcp-5671-allow'
            sourceIpGroups: [
              ipgCloudPcVnet.id
            ]
            destinationFqdns: [
              'global.azure-devices-provisioning.net'
              'hm-iot-in-prod-preu01.azure-devices.net'
              'hm-iot-in-prod-prna01.azure-devices.net'
              'hm-iot-in-prod-prap01.azure-devices.net'
              'hm-iot-in-prod-prau01.azure-devices.net'
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '5671'
            ]
          }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-app-avd-outbound-external-allow'
        priority: 210
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'avd-fqdnTag-https-allow'
            sourceIpGroups: [
              ipgAvdVnet.id
              ipgCloudPcVnet.id
            ]
            fqdnTags: [
              'WindowsUpdate'
              'Windows Diagnostics'
              'MicrosoftActiveProtectionService'
              'WindowsVirtualDesktop'
            ]
            protocols: [
              {
                port: 443
                protocolType: 'Https'
              }
            ]
            terminateTLS: false
          }
          {
            ruleType: 'ApplicationRule'
            name: 'avd-fqdn-https-allow'
            sourceIpGroups: [
              ipgAvdVnet.id
              ipgCloudPcVnet.id
            ]
            targetFqdns: [
              '*.events.data.microsoft.com'
              '*.sfx.ms'
              '*.digicert.com'
              '*.azure-dns.com'
              '*.azure-dns.net'
              'login.microsoftonline.com'
              'mrsglobalsteus2prod.blob.core.windows.net'
              'wvdportalstorageblob.blob.core.windows.net'
              'login.windows.net'
              'www.msftconnecttest.com'
              'gcs.prod.monitoring.core.windows.net'
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
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-app-intune-outbound-external-allow'
        priority: 220
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'intune-http-allow'
            description: 'Intune required HTTPS and HTTP URLs'
            sourceIpGroups: [
              ipgAvdVnet.id
              ipgCloudPcVnet.id
            ]
            targetFqdns: [
              '*.manage.microsoft.com'
              'manage.microsoft.com'
              '*.delivery.mp.microsoft.com'
              '*.prod.do.dsp.mp.microsoft.com'
              '*.update.microsoft.com'
              '*.windowsupdate.com'
              'emdl.ws.microsoft.com'
              'tsfe.trafficshaping.dsp.mp.microsoft.com'
              'time.windows.com'
              'www.msftconnecttest.com'
              'www.msftncsi.com'
              '*.s-microsoft.com'
              'clientconfig.passport.net'
              'windowsphone.com'
              'approdimedatahotfix.azureedge.net'
              'approdimedatapri.azureedge.net'
              'approdimedatasec.azureedge.net'
              'euprodimedatahotfix.azureedge.net'
              'euprodimedatapri.azureedge.net'
              'euprodimedatasec.azureedge.net'
              'naprodimedatahotfix.azureedge.net'
              'naprodimedatapri.azureedge.net'
              'naprodimedatasec.azureedge.net'
              'swda01-mscdn.azureedge.net'
              'swda02-mscdn.azureedge.net'
              'swdb01-mscdn.azureedge.net'
              'swdb02-mscdn.azureedge.net'
              'swdc01-mscdn.azureedge.net'
              'swdc02-mscdn.azureedge.net'
              'swdd01-mscdn.azureedge.net'
              'swdd02-mscdn.azureedge.net'
              'swdin01-mscdn.azureedge.net'
              'swdin02-mscdn.azureedge.net'
              '*.notify.windows.com'
              '*.wns.windows.com'
              '*.dl.delivery.mp.microsoft.com'
              '*.do.dsp.mp.microsoft.com'
              '*.emdl.ws.microsoft.com'
              'ekcert.spserv.microsoft.com'
              'ekop.intel.com'
              'ftpm.amd.com'
              'intunecdnpeasd.azureedge.net'
              '*.channelservices.microsoft.com'
              '*.go-mpulse.net'
              '*.infra.lync.com'
              '*.resources.lync.com'
              '*.support.services.microsoft.com'
              '*.trouter.skype.com'
              '*.vortex.data.microsoft.com'
              'edge.skype.com'
              'remoteassistanceprodacs.communication.azure.com'
              'lgmsapeweu.blob.core.windows.net'
            ]
            protocols: [
              {
                port: 443
                protocolType: 'Https'
              }
              {
                port: 80
                protocolType: 'Http'
              }
            ]
            terminateTLS: false
          }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-app-w365-cloudpc-outbound-external-allow'
        priority: 230
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'rc-w365-cloudpc-fqdnTag-https-allow'
            sourceIpGroups: [
              ipgCloudPcVnet.id
            ]
            fqdnTags: [
              'Windows365'
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
