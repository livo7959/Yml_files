@description('Region of the private endpoint')
param location string

@description('Array to deploy n number of private endpoints')
param private_endpoints array
param environment_name string
param vnet_name string
param subnet_name string
param rg_scope string = resourceGroup().name

resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' existing = {
  scope: resourceGroup(rg_scope)
  name: vnet_name
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' existing = {
  parent: vnet
  name: subnet_name
}

resource pe 'Microsoft.Network/privateEndpoints@2023-04-01' = [for (private_endpoint, idx) in private_endpoints: {
  name: 'pep-${private_endpoint.name}-${environment_name}'
  location: location
  tags: {
    environment: environment_name
  }
  properties: {
    privateLinkServiceConnections: [ for private_link_service_connection in private_endpoint.private_link_service_connections: {
      name: private_link_service_connection.service_connection_name
      properties: {
        privateLinkServiceId: resourceId(
          contains(private_link_service_connection.target_resource, 'resource_group_name') ? 'rg-${private_link_service_connection.target_resource.resource_group_name}-${environment_name}' : resourceGroup().name,
          private_link_service_connection.target_resource.resource_type,
          '${private_link_service_connection.target_resource.value}-${environment_name}'
        )
        groupIds: private_link_service_connection.group_ids
      }
    }]
    customNetworkInterfaceName: 'nic-pep-${private_endpoint.name}-${environment_name}'
    subnet: {
      id: subnet.id
    }
  }
}]

resource pe_dns_zone_groups 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-04-01' = [for (private_endpoint, idx) in private_endpoints: if(contains(private_endpoint, 'private_dns_zones')) {
  name: '${private_endpoint.name}-${environment_name}'
  parent: pe[idx]
  properties: {
    privateDnsZoneConfigs: [for private_dns_zone in private_endpoint.private_dns_zones: {
      name: private_dns_zone.name
      properties: {
        privateDnsZoneId: resourceId(
          contains(private_dns_zone, 'resource_group_name') ? 'rg-${private_dns_zone.resource_group_name}-${environment_name}' : resourceGroup().name,
          'Microsoft.Network/privateDnsZones', private_dns_zone.name
        )
      }
    }]
  }
}]
