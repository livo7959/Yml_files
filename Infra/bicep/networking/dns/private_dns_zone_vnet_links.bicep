param environment_name string
param private_dns_zone_names array
param vnet_name string

resource parent_private_dns_zones 'Microsoft.Network/privateDnsZones@2020-06-01' existing = [for private_dns_zone_name in private_dns_zone_names: {
  name: private_dns_zone_name
}]

resource virtual_network_link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = [for (private_dns_zone_name, idx) in private_dns_zone_names: {
  name: 'link-${vnet_name}'
  location: 'global'
  tags: {
    environment: environment_name
  }
  parent: parent_private_dns_zones[idx]
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', vnet_name)
    }
  }
}]
