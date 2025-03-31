@description('Name of rule collection group')
param rcgName string = 'rcg-office365-allow'

@description('Existing Firewall Policy Name')
param existingFwPolicyName string = 'policy-azfw-hub-eus-001'

resource fwPolicy 'Microsoft.Network/firewallPolicies@2022-07-01' existing = {
  name: existingFwPolicyName
}

// Declare existing IP Groups
resource ipGroupDevCloudPc 'Microsoft.Network/ipGroups@2022-07-01' existing = {
  name: 'ipg-cloudpc-dev-eus-001'
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
    priority: 1100
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
          destinationIpGroups: [
            ipgExoRequired.id
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
          destinationIpGroups: [
            ipgExoTcp443.id
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
            destinationIpGroups: [
              ipgSharepointOnedrive.id
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
            destinationIpGroups: [
              ipgTeamsTcp.id
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
            destinationIpGroups: [
              ipgO365Common.id
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
            description: 'EXO HTTP-S URLs'
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
          {
            ruleType: 'ApplicationRule'
            name: 'exchangeOnline-https-allow'
            description: 'EXO HTTPS only urls'
            sourceIpGroups: [
              ipGroupDevCloudPc.id
              ipgO365Internal.id
            ]
            targetFqdns: [
              '*.protection.outlook.com'
            ]
            protocols: [
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
        name: 'rc-app-sharepoint-onedrive-allow'
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
        name: 'rc-app-teams-skype-allow'
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
            targetFqdns: [
              '*.lync.com'
              '*.teams.microsoft.com'
              'teams.microsoft.com'
              '*.broadcast.skype.com' 
              'broadcast.skype.com'
              '*.sfbassets.com'
              '*.keydelivery.mediaservices.windows.net'
              '*.streaming.mediaservices.windows.net'
              'mlccdn.blob.core.windows.net'
              'aka.ms'
              '*.adl.windows.com'
              '	*.mstea.ms'
              '*.secure.skypeassets.com'
              'mlccdnprod.azureedge.net'
              '*.skype.com'
              '*.ecdn.microsoft.com'
              'compass-ssl.microsoft.com'
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
        name: 'rc-app-O365-common-allow'
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
            targetFqdns: [
              '*.microsoftstream.com'
              'nps.onyx.azure.net'
              '*.azureedge.net'
              '*.media.azure.net'
              '*.streaming.mediaservices.windows.net'
              '*.keydelivery.mediaservices.windows.net'
              '*.officeapps.live.com'
              '*.online.office.com'
              'office.live.com'
              '*.office.net'
              '*.onenote.com'
              '*cdn.onenote.net'
              'ajax.aspnetcdn.com'
              'apis.live.net' 
              'officeapps.live.com' 
              'www.onedrive.com'
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
              '*.compliance.microsoft.com'
              '*.protection.office.com'
              '*.security.microsoft.com'
              'compliance.microsoft.com'
              'defender.microsoft.com'
              'protection.office.com' 
              'security.microsoft.com'
              'account.office.net'
              '*.portal.cloudappsecurity.com'
              '*.aria.microsoft.com'
              '*.events.data.microsoft.com'
              '*.o365weve.com' 
              'amp.azure.net'
              'appsforoffice.microsoft.com'
              'assets.onestore.ms'
              'auth.gfx.ms'
              'c1.microsoft.com'
              'dgps.support.microsoft.com'
              'docs.microsoft.com'
              'msdn.microsoft.com'
              'platform.linkedin.com'
              'prod.msocdn.com'
              'shellprod.msocdn.com'
              'support.microsoft.com'
              'technet.microsoft.com'
              '*.office365.com'
              '*.aadrm.com'
              '*.azurerms.com'
              '*.informationprotection.azure.com'
              'ecn.dev.virtualearth.net'
              'informationprotection.hosting.portal.azure.net'
              'dc.services.visualstudio.com'
              'mem.gfx.ms'
              'staffhub.ms'
              '*.sharepointonline.com'
              'o15.officeredir.microsoft.com'
              'officepreviewredir.microsoft.com'
              'officeredir.microsoft.com'
              'r.office.microsoft.com'
              'activation.sls.microsoft.com'
              'crl.microsoft.com'
              'office15client.microsoft.com'
              'officeclient.microsoft.com'
              'go.microsoft.com'
              'ajax.aspnetcdn.com'
              'cdn.odc.officeapps.live.com'
              'officecdn.microsoft.com'
              'officecdn.microsoft.com.edgesuite.net'
              '*.assets-yammer.com'
              '*.yammer.com'
              '*.yammerusercontent.com'
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
              'officespeech.platform.bing.com'
              '*.microsoftusercontent.com'
              '*.office.com'
              'www.microsoft365.com'
              'cdnprod.myanalytics.microsoft.com'
              'myanalytics.microsoft.com'
              'myanalytics-gcc.microsoft.com'
              '*.azure-apim.net'
              '*.flow.microsoft.com'
              '*.powerapps.com'
              '*.activity.windows.com'
              'activity.windows.com'	
              '*.cortana.ai'
              'admin.microsoft.com'
              'cdn.odc.officeapps.live.com'
              'cdn.uci.officeapps.live.com'
              '*.cloud.microsoft'
            ]
            protocols: [
              {
                port: 443
                protocolType: 'Https'
              }
            ]
            terminateTLS: true
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
                port: 443
                protocolType: 'Https'
              }
            ]
          }
        ]
      }
    ]
  }
}
