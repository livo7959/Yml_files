param location string
param location_shortname string
param environment_name string

param virtual_networks array

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-09-01' = [for virtual_network in virtual_networks: {
  name: '${virtual_network.name}-${location_shortname}-${environment_name}'
  location: location
  tags: {
    environment: environment_name
  }
  properties: {
    addressSpace: {
      addressPrefixes: virtual_network.addressPrefixes[environment_name]
    }
    subnets: [for subnet in (virtual_network.?subnets ?? []): {
      name: '${subnet.name}-${location_shortname}-${environment_name}'
      properties: union({
        addressPrefix: subnet.addressPrefix[environment_name]
      },
      contains(subnet, 'serviceEndpoints') ? {
        serviceEndpoints: map(
          subnet.serviceEndpoints,
          service_endpoint => {
            locations: [location]
            service: service_endpoint
          }
        )
      }: {},
      contains(subnet, 'delegations') ? {
        delegations: map(
          subnet.delegations,
          delegation => {
            id: delegation.?id ?? ''
            name: delegation.?name ?? ''
            type: delegation.?type ?? ''
            properties: {
              serviceName: delegation.?service_name ?? ''
            }
          }
        )
      }: {},
      contains(subnet, 'privateEndpointNetworkPolicies') ? {
        privateEndpointNetworkPolicies: subnet.privateEndpointNetworkPolicies
      }: {},
      contains(subnet, 'privateLinkServiceNetworkPolicies') ? {
        privateLinkServiceNetworkPolicies: subnet.privateLinkServiceNetworkPolicies
      }: {},
      contains(subnet, 'networkSecurityGroup') ? {
        networkSecurityGroup: {
          id: resourceId('Microsoft.Network/networkSecurityGroups', '${subnet.networkSecurityGroup}-${location_shortname}-${environment_name}')
        }
      }: {},
      contains(subnet, 'natGateway') ?  {
        natGateway: {
          id: resourceId('Microsoft.Network/natGateways', 'ngw-${subnet.natGateway}-${environment_name}')
        }
      } : {})
    }]
  }
}]

module dns_zone_registration 'dns/private_dns_zone_vnet_links.bicep' = [for virtual_network in virtual_networks: if (contains(virtual_network, 'private_dns_zones')) {
  name: '${virtual_network.name}_dns_zone_registration'
  params: {
    environment_name: environment_name
    private_dns_zone_names: virtual_network.private_dns_zones
    vnet_name: '${virtual_network.name}-${location_shortname}-${environment_name}'
  }
  dependsOn: [
    virtualNetwork
  ]
}]
