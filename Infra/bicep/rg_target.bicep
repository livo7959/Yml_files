param location string = resourceGroup().location

@allowed([
  'sbox'
  'dev'
  'qa'
  'uat'
  'prod'
  'shared'
])
param environment_name string
param resource_group object

var location_shortname = loadJsonContent('./common_variables.json', 'location_shortnames')[location]

module managed_identity 'identity/managed_identity.bicep' = {
  name: 'managed_identity'
  params: {
    location: location
    environment_name: environment_name
    create_container_registry_id: contains(resource_group.resources, 'container_registries')
  }
}

module storage 'storage/storage.bicep' = {
  name: 'storage'
  params: {
    location: location
    environment_name: environment_name
    storageAccounts: resource_group.resources.?storageAccounts ?? []
  }
  dependsOn: [
    service_bus
  ]
}
module hosting_plan 'web/server_farms.bicep' = {
  name: 'hosting_plans'
  params: {
    location: location
    environment_name: environment_name
    hosting_plans: resource_group.resources.?hosting_plans ?? []
  }
  dependsOn: [
    storage
  ]
}

module service_bus 'service_bus/service_bus.bicep' = {
  name: 'service_bus'
  params: {
    location: location
    environment_name: environment_name
    serviceBusNamespaces: resource_group.resources.?serviceBusNamespaces ?? []
  }
}

module container_registry 'acr/acr.bicep' = {
  name: 'acr'
  params: {
    location: location
    environment_name: environment_name
    container_registries: resource_group.resources.?container_registries ?? []
    identity_id: managed_identity.outputs.container_app_mananged_identity_id
  }
  dependsOn: [
    managed_identity
  ]
}

module network_security 'networking/security/security_groups.bicep' = {
  name: 'networking_security'
  params: {
    location: location
    location_shortname: location_shortname
    environment_name: environment_name
    network_security_groups: resource_group.resources.?network_security_groups ?? []
  }
}

module private_dns_zones 'networking/dns/private_dns_zones.bicep' = {
  name: 'private_dns_zones'
  params: {
    environment_name: environment_name
    private_dns_zones: resource_group.resources.?private_dns_zones ?? []
  }
  dependsOn: [
    network_security
  ]
}

module nat_gateways 'networking/nat_gateways/nat_gateways.bicep' = {
  name: 'nat_gateways'
  params: {
    location: location
    environment_name: environment_name
    nat_gateways: resource_group.resources.?nat_gateways ?? []
  }
}

module virtual_network 'networking/vnet.bicep' = {
  name: 'vnet'
  params: {
    location: location
    location_shortname: location_shortname
    environment_name: environment_name
    virtual_networks: resource_group.resources.?virtual_networks ?? []
  }
  dependsOn: [
    network_security
    private_dns_zones
    nat_gateways
  ]
}

module private_endpoint 'networking/private_endpoints/private_endpoints.bicep' = [for private_endpoint in resource_group.resources.?private_endpoints ?? [] : {
  name: 'private_endpoint_${private_endpoint.name}'
  params: {
    location: location
    environment_name: environment_name
    private_endpoints: [private_endpoint]
    subnet_name: '${private_endpoint.network.subnet}-${location_shortname}-${environment_name}'
    vnet_name: '${private_endpoint.network.vnet}-${location_shortname}-${environment_name}'
    rg_scope: 'rg-${private_endpoint.network.resource_group_name}-${environment_name}'
  }
  dependsOn: [
    virtual_network
  ]
}]

module databricks 'databricks/databricks.bicep' = if (contains(resource_group.resources, 'databricks_workspaces')) {
  name: 'databricks'
  params: {
    location: location
    location_shortname: location_shortname
    environment_name: environment_name
    databricks_workspaces: resource_group.resources.databricks_workspaces
  }
  dependsOn: [
    network_security
    virtual_network
  ]
}

module private_endpoint_handler 'networking/private_endpoints/private_endpoint_handler.bicep' = [for virtual_network in resource_group.resources.?virtual_networks ?? []: {
  name: virtual_network.name
  params: {
    location: location
    location_shortname: location_shortname
    environment_name: environment_name
    vnet_name: '${virtual_network.name}-${location_shortname}-${environment_name}'
    subnets: virtual_network.?subnets ?? []
  }
  dependsOn: [
    databricks
  ]
}]

module container_app 'container_app/container_app.bicep' = {
  name: 'container_apps'
  params: {
    location: location
    environment_name: environment_name
    container_apps: resource_group.resources.?container_apps ?? []
    identity_id: managed_identity.outputs.container_app_mananged_identity_id
  }
  dependsOn: [
    container_registry
  ]
}

module key_vault_mod 'key_vault/vaults.bicep' = [for key_vault in (resource_group.resources.?key_vaults ?? []): {
  name: '${key_vault.name}_key_vault'
  params: {
    location: location
    environment_name: environment_name
    key_vault_name: key_vault.name
  }
}]

module data_factory_mod 'data_factory/factory.bicep' = [for data_factory in (resource_group.resources.?data_factories ?? []): {
  name: '${data_factory.name}_data_factory'
  params: {
    location: location
    environment_name: environment_name
    data_factory_basename: data_factory.name
    integration_runtimes: data_factory.integration_runtimes
  }
}]

module custom_roles 'roles/role_definitions/role_definition.bicep' = if (environment_name != 'shared') {
  name: 'custom_roles'
}

module role_assignment 'roles/role_assignments/custom_role_assignments/role_assignment.bicep' = if (environment_name != 'shared') {
  name: 'role_assignment'
  dependsOn: [
    custom_roles
  ]
}

module role_assignment_rg 'roles/role_assignments/role_assignment_rg.bicep' = {
  name: 'role_assignment_rg'
  params: {
    location: location
    environment_name: environment_name
    databricks_workspaces: resource_group.resources.?databricks_workspaces ?? []
    function_apps: reduce(
      resource_group.resources.?hosting_plans ?? [],
      [],
      (cur_function_apps, next_hosting_plan) => concat(cur_function_apps, next_hosting_plan.function_apps)
    )
    data_factories_with_role_assignments: filter(resource_group.resources.?data_factories_with_role_assignments ?? [], data_factory => data_factory.environment_name == environment_name)
  }
  dependsOn: [
    custom_roles
    databricks
    storage
  ]
}

module container_registry_role_assignment 'roles/role_assignments/container_registry/container_registry_role_assignments.bicep' = if (contains(resource_group.resources, 'container_registries')) {
  name: 'container_registry_role_assignment'
  params: {
    environment_name: environment_name
  }
}

module permissions_built_in_roles 'roles/role_assignments/built_in_role_assignments/built_in_role_assignment.bicep' = [for (role_assignment, idx) in (resource_group.permissions.?built_in_role_assignments ?? []): {
  name: 'built_in_role_assignments_${idx}'
  params: {
    description: role_assignment.description
    principal_id: role_assignment.principal_id
    principal_type: role_assignment.principal_type
    role_definition_id: role_assignment.role_definition_id
  }
}]
