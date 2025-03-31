targetScope = 'subscription'

param environment_name string
param resource_group_basename string
param location string

var resource_group_name = 'rg-${resource_group_basename}-${environment_name}'

resource resource_group 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resource_group_name
  location: location
  tags: {
    environment: environment_name
    created_by: 'bicep_az_cli'
  }
}

output resource_group_name string = resource_group_name
