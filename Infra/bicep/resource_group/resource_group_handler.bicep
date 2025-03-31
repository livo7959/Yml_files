targetScope = 'subscription'

param environment_name string

param resource_groups array

module resource_group_explicit './create_resource_group.bicep' = [for resource_group in resource_groups: {
  name: 'rg-${resource_group.name}-${environment_name}'
  params: {
    environment_name: environment_name
    location: resource_group.location
    resource_group_basename: resource_group.name
  }
}]
