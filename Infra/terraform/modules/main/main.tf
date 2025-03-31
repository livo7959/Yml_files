locals {
  # TODO enable for all envs. Working through network / permission issue publishing images before pulling to create container app
  container_app_configs = var.env == "sbox" ? flatten([
    for rg_name, rg_config in var.resource_groups : [
      for container_app_config in rg_config.resources.container_apps : {
        rg_basename          = rg_name
        container_app_config = container_app_config
      }
    ]
  ]) : []
  cdn_configs = flatten([
    for rg_name, rg_config in var.resource_groups : [
      for cdn_profile_config in rg_config.resources.cdn_profiles : {
        resource_group     = azurerm_resource_group.resource_groups[rg_name]
        cdn_profile_config = cdn_profile_config
      }
    ]
  ])
  container_registry_configs = flatten([
    for rg_name, rg_config in var.resource_groups : [
      for container_registry_config in rg_config.resources.container_registries : {
        resource_group            = azurerm_resource_group.resource_groups[rg_name]
        container_registry_config = container_registry_config
      }
    ]
  ])
  data_factory_configs = flatten([
    for rg_name, rg_config in var.resource_groups : [
      for data_factory_config in rg_config.resources.data_factories : {
        resource_group      = azurerm_resource_group.resource_groups[rg_name]
        data_factory_config = data_factory_config
      }
    ]
  ])
  virtual_network_configs = flatten([
    for rg_name, rg_config in var.resource_groups : [
      for vnet_config in rg_config.resources.virtual_networks : {
        resource_group         = azurerm_resource_group.resource_groups[rg_name]
        virtual_network_config = vnet_config
      }
    ]
  ])
  nat_gateways = flatten([
    for rg_name, rg_config in var.resource_groups : [
      for nat_gateway in rg_config.resources.nat_gateways : {
        resource_group   = azurerm_resource_group.resource_groups[rg_name]
        nat_gateway_name = nat_gateway
      }
    ]
  ])
  nsg_configs = flatten([
    for rg_name, rg_config in var.resource_groups : [
      for nsg_config in rg_config.resources.network_security_groups : {
        resource_group         = azurerm_resource_group.resource_groups[rg_name]
        network_security_group = nsg_config
      }
    ]
  ])
  private_dns_zones = flatten([
    for rg_name, rg_config in var.resource_groups : [
      for private_dns_zone in rg_config.resources.private_dns_zones : {
        resource_group   = azurerm_resource_group.resource_groups[rg_name]
        private_dns_zone = private_dns_zone
      }
    ]
  ])
  databricks_configs = flatten([
    for rg_name, rg_config in var.resource_groups : [
      for databricks_workspace in rg_config.resources.databricks_workspaces : {
        resource_group    = azurerm_resource_group.resource_groups[rg_name]
        databricks_config = databricks_workspace
      }
    ]
  ])
  storage_account_configs = flatten([
    for rg_name, rg_config in var.resource_groups : [
      for storage_account in rg_config.resources.storage_accounts : {
        resource_group         = azurerm_resource_group.resource_groups[rg_name]
        storage_account_config = storage_account
      }
    ]
  ])
  key_vault_configs = flatten([
    for rg_name, rg_config in var.resource_groups : [
      for key_vault_id, key_vault_config in rg_config.resources.key_vaults : {
        resource_group   = azurerm_resource_group.resource_groups[rg_name]
        key_vault_id     = key_vault_id
        key_vault_config = key_vault_config
      }
    ]
  ])
  service_bus_configs = flatten([
    for rg_name, rg_config in var.resource_groups : [
      for service_bus_id, service_bus_config in rg_config.resources.service_bus : {
        resource_group     = azurerm_resource_group.resource_groups[rg_name]
        service_bus_id     = service_bus_id
        service_bus_config = service_bus_config
      }
    ]
  ])
  role_definition_configs = flatten([
    for rg_name, rg_config in var.resource_groups : [
      for role_definition in rg_config.resources.role_definitions : {
        resource_group         = azurerm_resource_group.resource_groups[rg_name]
        role_definition_config = role_definition
      }
    ]
  ])
  common_tags = {
    environment = var.env
    created_by  = "terraform"
  }
}

data "azurerm_subscription" "current" {}
