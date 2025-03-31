@description('name of the new virtual network where DNS resolver will be created')
param resolverVNETName string = 'vnet-hub-eus-001'

@description('the IP address space for the resolver virtual network')
param resolverVNETAddressSpace string = '10.120.0.0/20'

@description('name of the dns private resolver')
param dnsResolverName string = 'dns-resolver-hub-eus-001'

@description('the location for resolver VNET and dns private resolver - Azure DNS Private Resolver available in specific region, refer the documenation to select the supported region for this deployment. For more information https://docs.microsoft.com/azure/dns/dns-private-resolver-overview#regional-availability')
param location string = resourceGroup().location

@description('name of the  private resolver inbound endpoint')
param inboundDNSResolverName string = 'dnsr-inbound-eus-001'

@description('name of the subnet that will be used for private resolver inbound endpoint')
param inboundSubnet string = 'snet-dnsr-inbound-eus-002'

@description('the inbound endpoint subnet address space')
param inboundAddressPrefix string = '10.120.1.128/26'

@description('name of the  private resolver outbound endpoint')
param outboundDNSResolverName string = 'dnsr-outbound-eus-001'

@description('name of the subnet that will be used for private resolver outbound endpoint')
param outboundSubnet string = 'snet-dnsr-outbound-eus-001'

@description('the outbound endpoint subnet address space')
param outboundAddressPrefix string = '10.120.1.64/26'

@description('resolver vnet to link')
param resolverVnetToLink string = 'vnet-cloudpc-eus-001'

@description('name of the vnet link that links outbound endpoint with forwarding rule set')
param resolvervnetlink string = 'link-vnet-cloudpc-eus-001'

@description('name of the forwarding ruleset')
param forwardingRulesetName string = 'dnsfwd-ruleset-hub-eus-001'

@description('name of the forwarding rule name')
param forwardingRuleName string = 'corp-logixhealth-local'

@description('the target domain name for the forwarding ruleset')
param DomainName string = 'corp.logixhealth.local.'

@description('the list of target DNS servers ip address and the port number for conditional forwarding')
param targetDNS array = [
    {
      ipaddress: '10.10.32.202'
      port: 53
    }
    {
      ipaddress: '10.10.32.205'
      port: 53
    }
    {
      ipaddress: '10.10.24.8'
      port: 53
    }
    {
      ipaddress: '10.10.24.9'
      port: 53
    }
  ]

@description('name of the forwarding rule name')
param lhLocalForwardingRuleName string = 'logixhealth-local'

@description('the target domain name for the forwarding ruleset')
param lhLocalDomainName string = 'logixhealth.local.'

@description('the list of target DNS servers ip address and the port number for conditional forwarding')
param lhLocaltargetDNS array = [
    {
      ipaddress: '10.10.32.200'
      port: 53
    }
    {
      ipaddress: '10.10.32.208'
      port: 53
    }
    {
      ipaddress: '10.10.24.5'
      port: 53
    }
    {
      ipaddress: '10.10.24.7'
      port: 53
    }
  ]

  @description('name of the forwarding rule name')
  param lhComForwardingRuleName string = 'logixhealth-com'
  
  @description('the target domain name for the forwarding ruleset')
  param lhComDomainName string = 'logixhealth.com.'
  
  @description('the list of target DNS servers ip address and the port number for conditional forwarding')
  param lhComtargetDNS array = [
      {
        ipaddress: '10.10.32.34'
        port: 53
      }
      {
        ipaddress: '10.10.32.38'
        port: 53
      }
    ]

resource resolverVnet 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: resolverVNETName
}

resource linkedVnet 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: resolverVnetToLink
  scope: resourceGroup('rg-net-vdi-eus-001')
}

resource resolver 'Microsoft.Network/dnsResolvers@2022-07-01' = {
  name: dnsResolverName
  location: location
  properties: {
    virtualNetwork: {
      id: resolverVnet.id
    }
  }
}

resource inEndpoint 'Microsoft.Network/dnsResolvers/inboundEndpoints@2022-07-01' = {
  parent: resolver
  name: inboundDNSResolverName
  location: location
  properties: {
    ipConfigurations: [
      {
        privateIpAllocationMethod: 'Dynamic'
        subnet: {
          id: '${resolverVnet.id}/subnets/${inboundSubnet}'
        }
      }
    ]
  }
}

resource outEndpoint 'Microsoft.Network/dnsResolvers/outboundEndpoints@2022-07-01' = {
  parent: resolver
  name: outboundDNSResolverName
  location: location
  properties: {
    subnet: {
      id: '${resolverVnet.id}/subnets/${outboundSubnet}'
    }
  }
}

resource fwruleSet 'Microsoft.Network/dnsForwardingRulesets@2022-07-01' = {
  name: forwardingRulesetName
  location: location
  properties: {
    dnsResolverOutboundEndpoints: [
      {
        id: outEndpoint.id
      }
    ]
  }
}

resource resolverLink 'Microsoft.Network/dnsForwardingRulesets/virtualNetworkLinks@2022-07-01' = {
  parent: fwruleSet
  name: resolvervnetlink
  properties: {
    virtualNetwork: {
      id: linkedVnet.id
    }
  }
}

resource fwRules 'Microsoft.Network/dnsForwardingRulesets/forwardingRules@2022-07-01' = {
  parent: fwruleSet
  name: forwardingRuleName
  properties: {
    domainName: DomainName
    targetDnsServers: targetDNS
  }
}

resource lhComFwRules 'Microsoft.Network/dnsForwardingRulesets/forwardingRules@2022-07-01' = {
  parent: fwruleSet
  name: lhComForwardingRuleName
  properties: {
    domainName: lhComDomainName
    targetDnsServers: lhComtargetDNS
  }
}

resource lhLocalRules 'Microsoft.Network/dnsForwardingRulesets/forwardingRules@2022-07-01' = {
  parent: fwruleSet
  name: lhLocalForwardingRuleName
  properties: {
    domainName: lhLocalDomainName
    targetDnsServers: lhLocaltargetDNS
  }
}

resource obSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: outboundSubnet
  parent: resolverVnet
  properties: {
    addressPrefix: outboundAddressPrefix
  }
}

resource ibSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: inboundSubnet
  parent: resolverVnet
  properties: {
    addressPrefix: inboundAddressPrefix
  }
}
