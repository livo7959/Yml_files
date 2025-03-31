param environment_name string
param private_dns_zones array

resource private_dns_zone_resources 'Microsoft.Network/privateDnsZones@2020-06-01' = [for private_dns_zone in private_dns_zones: {
  name: private_dns_zone.name
  location: 'global'
  tags: {
    environment: environment_name
  }
}]
