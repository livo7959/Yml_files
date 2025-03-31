@description('Name of rule collection group')
param rcgName string = 'rcg-office365-allow'

@description('Existing Firewall Policy Name')
param existingFwPolicyName string = 'policy-azfw-hub-eus-001'

resource fwPolicy 'Microsoft.Network/firewallPolicies@2022-07-01' existing = {
  name: existingFwPolicyName
}

// Declare existing IP Groups
resource ipGroupDevCloudPc 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-cloudpc-internal'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgTcp25 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-exchangeOnline-tcp-25'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgExoTcp443 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-exchangeOnline-tcp-443'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgExoRequired 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-exchangeOnline-required'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgO365Internal 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-office365-internal-allowed'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgSharepointOnedrive 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-sharepoint-onedrive-required'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgTeamsTcp 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-teams-skype-tcp-required'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgTeamsUdp 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-teams-skype-udp-required'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource ipgO365Common 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-O365-common-tcp-required'
  scope: resourceGroup('rg-ip-groups-hub-001')
}

resource rcg 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2022-07-01' = {
  name: rcgName
  parent: fwPolicy
  properties: {
    priority: 1300
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-net-exchangeOnline-outbound-external-allow'
        priority: 110
        action: {
          type: 'Allow'
        }
        rules: [
        {
          name: 'exchangeOnline-tcp-allow'
          ruleType: 'NetworkRule'
          description: 'TCP 80,443,587 for Exchange Online'
          sourceIpGroups: [
            ipGroupDevCloudPc.id
            ipgO365Internal.id
          ]
          destinationAddresses: [
            'Office365.Exchange.Optimize'
            'Office365.Exchange.Allow.Required'
          ]
          ipProtocols: [
            'TCP'
          ]
          destinationPorts: [
            '80'
            '443'
            '587'
          ]
        }
        {
          ruleType: 'NetworkRule'
          name: 'exchangeOnline-smtp587-fqdn-allow'
          sourceIpGroups: [
            ipGroupDevCloudPc.id
            ipgO365Internal.id
          ]
          destinationFqdns: [
            'smtp.office.com'
          ]
          ipProtocols: [
            'TCP'
          ]
          destinationPorts: [
            '587'
          ]
        }
        {
          name: 'exchangeOnline-udp-allow'
          ruleType: 'NetworkRule'
          description: 'UDP 443 for Exchange Online'
          sourceIpGroups: [
            ipGroupDevCloudPc.id
            ipgO365Internal.id
          ]
          destinationIpGroups: [
            ipgExoRequired.id
          ]
          ipProtocols: [
            'UDP'
          ]
          destinationPorts: [
            '443'
          ]
        }
        {
          name: 'exchangeOnline-tcp-443-allow'
          ruleType: 'NetworkRule'
          description: 'Exchange Online TCP 443 IPs'
          sourceIpGroups: [
            ipGroupDevCloudPc.id
            ipgO365Internal.id
          ]
          destinationAddresses: [
            'Office365.Exchange.Optimize'
            'Office365.Exchange.Allow.Required'
          ]
          ipProtocols: [
            'TCP'
          ]
          destinationPorts: [
            '443'
          ]
        }
        {
          name: 'exchangeOnline-smtp25-allow'
          ruleType: 'NetworkRule'
          description: 'Exchange Online SMTP25 IPs'
          sourceIpGroups: [
            ipGroupDevCloudPc.id
            ipgO365Internal.id
          ]
          destinationIpGroups: [
            ipgTcp25.id
          ]
          ipProtocols: [
            'TCP'
          ]
          destinationPorts: [
            '25'
          ]
        }

        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-net-sharepoint-onedrive-outbound-external-allow'
        action: {
          type: 'Allow'
        }
        priority: 120
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'sharepoint-onedrive-tcp-allow'
            sourceIpGroups: [
              ipGroupDevCloudPc.id
              ipgO365Internal.id
            ]
            destinationAddresses: [
              'Office365.SharePoint.Optimize'
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '80'
              '443'
            ]
          }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-net-teams-outbound-external-allow'
        priority: 130
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'teams-skype-udp-allow'
            sourceIpGroups: [
              ipGroupDevCloudPc.id
              ipgO365Internal.id
            ]
            destinationIpGroups: [
              ipgTeamsUdp.id
            ]
            ipProtocols: [
              'UDP'
            ]
            destinationPorts: [
              '3478'
              '3479'
              '3480'
              '3481'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'teams-skype-tcp-allow'
            sourceIpGroups: [
              ipGroupDevCloudPc.id
              ipgO365Internal.id
            ]
            destinationAddresses: [
              'Office365.Skype.Optimize'
              'Office365.Skype.Allow.Required'
            ]
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '80'
              '443'
            ]
          }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-net-O365-common-outbound-external-allow'
        priority: 140
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'O365-common-tcp-allow'
            sourceIpGroups: [
              ipGroupDevCloudPc.id
              ipgO365Internal.id
            ]
            destinationAddresses: [
              'Office365.Common.Allow.Required'
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
        name: 'rc-app-exchangeOnline-outbound-external-allow'
        priority: 210
        action: {
          type: 'Allow'
        }
        rules: [
          {
            name: 'exchangeOnline-http-allow'
            ruleType: 'ApplicationRule'
            description: 'EXO http URLs'
            sourceIpGroups: [
              ipGroupDevCloudPc.id
              ipgO365Internal.id
            ]
            targetFqdns: [
              'outlook.office.com'
              'outlook.office365.com'
              '*.outlook.com'
              'autodiscover.logixhealthinc.onmicrosoft.com'	
            ]
            protocols: [
              {
                port: 80
                protocolType: 'Http'
              }
            ]
          }
          {
            ruleType: 'ApplicationRule'
            name: 'exchangeOnline-https-allow'
            description: 'EXO https urls'
            sourceIpGroups: [
              ipGroupDevCloudPc.id
              ipgO365Internal.id
            ]
            fqdnTags: [
              'Office365.Exchange.Allow.Required'
              'Office365.Exchange.Allow.NotRequired'
              'Office365.Exchange.Optimize'
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
        name: 'rc-app-sharepoint-onedrive-outbound-external-allow'
        priority: 220
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'sharepoint-onedrive-https-allow'
            sourceIpGroups: [
              ipGroupDevCloudPc.id
              ipgO365Internal.id
            ]
            fqdnTags: [
              'Office365.SharePoint.Default.Required'
              'Office365.SharePoint.Default.NotRequired'
              'Office365.SharePoint.Optimize'
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
            name: 'sharepoint-onedrive-http-allow'
            sourceIpGroups: [
              ipGroupDevCloudPc.id
              ipgO365Internal.id
            ]
            targetFqdns: [
              '*.sharepoint.com'
              '*.wns.windows.com'
              'admin.onedrive.com'
              'officeclient.microsoft.com'
              'g.live.com'
              'oneclient.sfx.ms'
              '*.sharepointonline.com'
              'spoprod-a.akamaihd.net'
              '*.svc.ms'	
            ]
            protocols: [
              {
                port: 80
                protocolType: 'Http'
              }
            ]
          }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-app-teams-skype-outbound-external-allow'
        priority: 230
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'teams-skype-https-allow'
            sourceIpGroups: [
              ipGroupDevCloudPc.id
              ipgO365Internal.id
            ]
            fqdnTags: [
              'Office365.Skype.Default.Required'
              'Office365.Skype.Allow.Required'
              'Office365.Skype.Default.NotRequired'
              'Office365.Skype.Allow.NotRequired'
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
            name: 'teams-skype-http-allow'
            sourceIpGroups: [
              ipGroupDevCloudPc.id
              ipgO365Internal.id
            ]
            targetFqdns: [
              '*.lync.com'
              '*.teams.microsoft.com'
              'teams.microsoft.com'
              '*.sfbassets.com'
              '*.adl.windows.com'
              '*.skype.com'
            ]
            protocols: [
              {
                port: 80
                protocolType: 'Http'
              }
            ]
          }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-app-O365-common-outbound-external-allow'
        priority: 240
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'O365-common-https-allow'
            sourceIpGroups: [
              ipGroupDevCloudPc.id
              ipgO365Internal.id
            ]
            fqdnTags: [
              'Office365.Common.Allow.Required'
              'Office365.Common.Default.Required'
              'Office365.Common.Default.NotRequired'
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
            name: 'O365-common-http-allow'
            sourceIpGroups: [
              ipGroupDevCloudPc.id
              ipgO365Internal.id
            ]
            targetFqdns: [
              '*.officeapps.live.com'
              '*.online.office.com'
              'office.live.com'
              '*.office.net'
              '*.auth.microsoft.com'
              '*.msftidentity.com'
              '*.msidentity.com' 
              'account.activedirectory.windowsazure.com'
              'accounts.accesscontrol.windows.net' 
              'adminwebservice.microsoftonline.com'
              'api.passwordreset.microsoftonline.com'
              'autologon.microsoftazuread-sso.com' 
              'becws.microsoftonline.com' 
              'ccs.login.microsoftonline.com'
              'clientconfig.microsoftonline-p.net'
              'companymanager.microsoftonline.com' 
              'device.login.microsoftonline.com' 
              'graph.microsoft.com'
              'graph.windows.net'
              'login.microsoft.com' 
              'login.microsoftonline.com'
              'login.microsoftonline-p.com' 
              'login.windows.net' 
              'logincert.microsoftonline.com' 
              'loginex.microsoftonline.com'
              'login-us.microsoftonline.com'
              'nexus.microsoftonline-p.com'
              'passwordreset.microsoftonline.com'
              'provisioningapi.microsoftonline.com'
              '*.hip.live.com'
              '*.microsoftonline.com' 
              '*.microsoftonline-p.com' 
              '*.msauth.net'
              '*.msauthimages.net'
              '*.msecnd.net'
              '*.msftauth.net'
              '*.msftauthimages.net'
              '*.phonefactor.net'
              'enterpriseregistration.windows.net'
              'management.azure.com'
              'policykeyservice.dc.ad.msft.net'
              '*.office365.com'
              'o15.officeredir.microsoft.com'
              'officepreviewredir.microsoft.com'
              'officeredir.microsoft.com'
              'r.office.microsoft.com'
              'crl.microsoft.com'
              'go.microsoft.com'
              'ajax.aspnetcdn.com'
              'cdn.odc.officeapps.live.com'
              'officecdn.microsoft.com'
              'officecdn.microsoft.com.edgesuite.net'
              'www.outlook.com'
              '*.entrust.net'
              '*.geotrust.com'
              '*.omniroot.com'
              '*.public-trust.com'
              '*.symcb.com'
              '*.symcd.com'
              '*.verisign.com'
              '*.verisign.net'
              'apps.identrust.com'
              'cacerts.digicert.com'
              'cert.int-x3.letsencrypt.org'
              'crl.globalsign.com'
              'crl.globalsign.net'
              'crl.identrust.com'
              'crl3.digicert.com'
              'crl4.digicert.com'
              'isrg.trustid.ocsp.identrust.com'
              'mscrl.microsoft.com'
              'ocsp.digicert.com'
              'ocsp.globalsign.com'
              'ocsp.msocsp.com'
              'ocsp2.globalsign.com'
              'ocspx.digicert.com'
              'secure.globalsign.com'
              'www.digicert.com'
              'www.microsoft.com'
              '*.office.com'
              'www.microsoft365.com'
              'cdnprod.myanalytics.microsoft.com'
              'myanalytics.microsoft.com'
              'myanalytics-gcc.microsoft.com'
              'admin.microsoft.com'
              'cdn.odc.officeapps.live.com'
              'cdn.uci.officeapps.live.com'
              '*.cloud.microsoft'
              'ocsp.int-x3.letsencrypt.org'
            ]
            protocols: [
              {
                port: 80
                protocolType: 'Http'
              }
            ]
          }
        ]
      }
    ]
  }
}
