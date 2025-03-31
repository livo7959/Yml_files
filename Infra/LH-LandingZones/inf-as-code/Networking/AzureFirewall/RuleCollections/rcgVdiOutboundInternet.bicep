@description('Name of rule collection group')
param rcgName string = 'rcg-vdi-outbound-internet-allow'

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

resource rcg 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2022-09-01' = {
  name: rcgName
  parent: fwPolicy
  properties: {
    priority: 5000
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-app-vdi-deny'
        priority: 200
        action: {
          type: 'Deny'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'vdi-all-targetFqdn-deny'
            description: 'VDI Denied target fqdns'
            sourceIpGroups: [
              ipgAvdVnet.id
              ipgCloudPcVnet.id
            ]
            targetFqdns: [
              'drive.google.com'
              '*.dropbox.com'
              '*.egnyte.com'
              '*.naukri.com'
              '*.linkedin.com'
              '*.box.com'
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
            terminateTLS: true
          }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-app-vdi-dev-outbound-internet-tls-inspection-disabled-allow'
        priority: 210
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'vdi-dev-https-urls-tls-inspection-disabled-allow'
            description: 'URLs requiring TLS Decryption disabled'
            sourceIpGroups: [
              ipgCloudPcVnet.id
            ]
            targetFqdns: [
              '*.api.powerplatform.com'
              '*.crm.dynamics.com'
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
        name: 'rc-app-vdi-dev-outbound-internet-url-allow'
        priority: 220
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'vdi-dev-urls-http-allowed'
            description: 'URLs allowed for VDI Dev users'
            sourceIpGroups: [
              ipgCloudPcVnet.id
            ]
            targetFqdns: [
              '*.zinghr.com'
              'zingnext.zinghr.com'
              'www.eclipse.org'
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
        name: 'rc-app-vdi-dev-outbound-internet-webcategories-allow'
        priority: 230
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'vdi-dev-web-categories-http-allow'
            sourceIpGroups: [
              ipgCloudPcVnet.id
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
            webCategories: [
              'Business'
              'ComputersAndTechnology'
              'Education'
              'Finance'
              'ForumsAndNewsgroups'
              'Government'
              'HealthAndMedicine'
              'InformationSecurity'
              'News'
              'NonprofitsAndNGOs'
              'Professionalnetworking'
              'SearchEnginesAndPortals'
              'Translators'
              'WebBasedemail'
              'WebrepositoryAndStorage'
            ]
            terminateTLS: true
          }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-app-vdi-ops-outbound-internet-tls-inspection-disabled-allow'
        priority: 310
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'vdi-ops-outbound-internet-web-categories-tls-inspection-exempt'
            sourceIpGroups: [
              ipgAvdVnet.id
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
            webCategories: [
              'HealthAndMedicine'
              'Education'
              'Finance'
              'Government'
            ]
            terminateTLS: false
          }
          {
            ruleType: 'ApplicationRule'
            name: 'vdi-ops-targetFqdn-tls-inspection-exempt'
            sourceIpGroups: [
              ipgAvdVnet.id
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
            targetFqdns: [
              'nwlssoctx.ps-msite.com'
              'cwxsecurelink.cernerworks.com'
              '*.northwell.edu'
              'impr1.co'
              'encrypt.barracudanetworks.com'
              'kdremote.chkd.org'
              '*.api.powerplatform.com'
              '*.crm.dynamics.com'
              '*.s3.us-east-2.amazonaws.com'
              'mail.teamghbp.com'
              'pdqinstallers.e9d69694c3d8f7465fd531512c22bd0f.r2.cloudflarestorage.com'
              'connect-package-library.e9d69694c3d8f7465fd531512c22bd0f.r2.cloudflarestorage.com'
              'connect.e9d69694c3d8f7465fd531512c22bd0f.r2.cloudflarestorage.com'
            ]
            terminateTLS: false
          }
          {
            ruleType: 'ApplicationRule'
            name: 'vdi-ops-targetFqdn-8443-tls-inspection-exempt'
            sourceIpGroups: [
              ipgAvdVnet.id
            ]
            protocols: [
              {
                port: 8443
                protocolType: 'Https'
              }
            ]
            targetFqdns: [
              '*.service.vumc.org'
              'desktop.einstein.edu'
              'connect.carene.org'
            ]
            terminateTLS: false
          }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-app-vdi-ops-outbound-internet-url-allow'
        priority: 320
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'vdi-ops-targetFqdn-http-allowed'
            description: 'Target FQDNs allowed for VDI Operations users'
            sourceIpGroups: [
              ipgAvdVnet.id
            ]
            targetFqdns: [
              'aapc.com'
              '*.zinghr.com'
              'zingnext.zinghr.com'
              'www.surveymonkey.com'
              'www.ncinno.org'
              'protect-us.mimecast.com'
              'tools.usps.com'
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
          {
            ruleType: 'ApplicationRule'
            name: 'vdi-ops-targetUrl-http-allowed'
            description: 'Target URLs allowed for VDI Operations users'
            sourceIpGroups: [
              ipgAvdVnet.id
            ]
            targetUrls: [
              'x12.org/codes/claim-adjustment-reason-codes'
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
        name: 'rc-app-vdi-ops-outbound-internet-webcategories-allow'
        priority: 330
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'vdi-ops-web-categories-http-allow'
            sourceIpGroups: [
              ipgAvdVnet.id
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
            webCategories: [
              'Business'
              'ComputersAndTechnology'
              'InformationSecurity'
              'News'
              'NonprofitsAndNGOs'
              'SearchEnginesAndPortals'
              'Translators'
              'ProfessionalNetworking'
            ]
            terminateTLS: true
          }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'rc-app-vdi-all-outbound-internet-allow'
        priority: 340
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            description: 'VDI All https only urls'
            name: 'vdi-all-targetFqdn-https-allow'
            sourceIpGroups: [
              ipgAvdVnet.id
              ipgCloudPcVnet.id
            ]
            targetFqdns: [
              'websocket.app.pdq.com'
              'cfcdn.pdq.com'
              'app.pdq.com'
                           
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
    ]
  }
}
