param location string
param location_shortname string
param environment_name string
param vnet_name string
param subnets array

module privateEndpoints 'private_endpoints.bicep' = [for subnet in subnets: {
  name: subnet.name
  params: {
    location: location
    private_endpoints: subnet.?private_endpoints ?? []
    environment_name: environment_name
    vnet_name: vnet_name
    subnet_name: '${subnet.name}-${location_shortname}-${environment_name}'
  }
}]
