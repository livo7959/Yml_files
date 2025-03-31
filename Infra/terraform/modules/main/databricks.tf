locals {
  databricks_managed_rg_basename   = "databricks-managed"
  databricks_managed_identity_name = "dbmanagedidentity"
  databricks_key_vault_prefix      = "dbk"
}

data "azurerm_client_config" "current" {}

module "databricks_name" {
  source = "../naming"

  for_each = {
    for idx, each in local.databricks_configs :
    each.databricks_config.name => each
  }

  resource_type = "databricks"
  env           = var.env
  location      = each.value.resource_group.location
  name          = each.value.databricks_config.name
}

module "databricks_managed_rg_name" {
  source = "../naming"

  for_each = {
    for idx, each in local.databricks_configs :
    each.databricks_config.name => each
  }

  resource_type = "resource_group"
  env           = var.env
  location      = each.value.resource_group.location
  name          = "${local.databricks_managed_rg_basename}-${each.value.databricks_config.name}"
}

resource "azurerm_databricks_workspace" "databricks_workspace" {
  for_each = {
    for idx, each in local.databricks_configs :
    each.databricks_config.name => each
  }

  name                                  = module.databricks_name[each.key].name
  resource_group_name                   = each.value.resource_group.name
  location                              = each.value.resource_group.location
  sku                                   = each.value.databricks_config.sku
  managed_resource_group_name           = module.databricks_managed_rg_name[each.key].name
  network_security_group_rules_required = "NoAzureDatabricksRules"
  public_network_access_enabled         = false
  custom_parameters {
    no_public_ip                                         = true
    virtual_network_id                                   = azurerm_virtual_network.vnet[each.value.databricks_config.network.virtual_network].id
    public_subnet_name                                   = azurerm_subnet.subnets["${each.value.databricks_config.network.virtual_network}~${each.value.databricks_config.network.public_subnet}"].name
    private_subnet_name                                  = azurerm_subnet.subnets["${each.value.databricks_config.network.virtual_network}~${each.value.databricks_config.network.private_subnet}"].name
    public_subnet_network_security_group_association_id  = azurerm_subnet.subnets["${each.value.databricks_config.network.virtual_network}~${each.value.databricks_config.network.public_subnet}"].id
    private_subnet_network_security_group_association_id = azurerm_subnet.subnets["${each.value.databricks_config.network.virtual_network}~${each.value.databricks_config.network.private_subnet}"].id
  }

  tags = local.common_tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_databricks_access_connector" "databricks_access_connector" {
  for_each = {
    for idx, each in local.databricks_configs :
    each.databricks_config.name => each
  }

  name                = module.databricks_name[each.value.databricks_config.name].name
  resource_group_name = each.value.resource_group.name
  location            = each.value.resource_group.location

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

locals {
  private_endpoints = flatten([
    for databricks_config in local.databricks_configs : [
      for private_endpoint in databricks_config.databricks_config.private_endpoints : {
        databricks_config = databricks_config
        private_endpoint  = private_endpoint
      }
    ]
  ])
}

module "private_endpoint_name" {
  source = "../naming"

  for_each = {
    for private_endpoint in local.private_endpoints :
    "${private_endpoint.databricks_config.databricks_config.name}~${private_endpoint.private_endpoint.name}" => private_endpoint
  }

  resource_type = "private_endpoint"
  env           = var.env
  location      = each.value.databricks_config.resource_group.location
  name          = each.value.private_endpoint.name
}

module "network_interface_name" {
  source = "../naming"

  for_each = {
    for idx, private_endpoint in local.private_endpoints :
    "${private_endpoint.databricks_config.databricks_config.name}~${private_endpoint.private_endpoint.name}" => private_endpoint
  }

  resource_type = "network_interface"
  env           = var.env
  location      = each.value.databricks_config.resource_group.location
  name          = module.private_endpoint_name[each.key].basename
}

resource "azurerm_private_endpoint" "private_endpoint" {
  for_each = {
    for idx, private_endpoint in local.private_endpoints :
    "${private_endpoint.databricks_config.databricks_config.name}~${private_endpoint.private_endpoint.name}" => private_endpoint
  }

  name                = module.private_endpoint_name[each.key].name
  location            = each.value.databricks_config.resource_group.location
  resource_group_name = each.value.databricks_config.resource_group.name
  subnet_id           = azurerm_subnet.subnets["${each.value.private_endpoint.vnet}~${each.value.private_endpoint.subnet}"].id

  tags = local.common_tags

  custom_network_interface_name = module.network_interface_name[each.key].name

  dynamic "private_dns_zone_group" {
    for_each = each.value.private_endpoint.private_dns_zone_name != null ? [each.value.private_endpoint.private_dns_zone_name] : []
    content {
      private_dns_zone_ids = [
        azurerm_private_dns_zone.private_dns_zone[private_dns_zone_group.value].id
      ]
      name = private_dns_zone_group.value
    }
  }

  private_service_connection {
    name                           = each.value.private_endpoint.private_link_service_connection.name
    private_connection_resource_id = azurerm_databricks_workspace.databricks_workspace[each.value.databricks_config.databricks_config.name].id
    is_manual_connection           = false
    subresource_names              = each.value.private_endpoint.private_link_service_connection.subresource_names
  }
}

module "databricks_key_vault_name" {
  source = "../naming"

  for_each = {
    for idx, each in local.databricks_configs :
    each.databricks_config.name => each
  }

  resource_type = "key_vault"
  env           = var.env
  location      = each.value.resource_group.location
  name          = "${local.databricks_key_vault_prefix}-${each.value.databricks_config.name}"
}

resource "azurerm_key_vault" "databricks_key_vault" {
  for_each = {
    for idx, each in local.databricks_configs :
    each.databricks_config.name => each
  }

  name                       = module.databricks_key_vault_name[each.key].name
  location                   = each.value.resource_group.location
  resource_group_name        = each.value.resource_group.name
  tenant_id                  = data.azurerm_subscription.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  public_network_access_enabled   = true // set to true to turn on the below defined network_acls
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = true
  enable_rbac_authorization       = true

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"

    ip_rules = [
      "66.97.189.250"
    ]
    virtual_network_subnet_ids = [
      azurerm_subnet.subnets["${each.value.databricks_config.network.virtual_network}~${each.value.databricks_config.network.public_subnet}"].id
    ]
  }

  tags = local.common_tags
}

resource "azurerm_role_assignment" "kv_secret_user" {
  for_each = {
    for idx, each in local.databricks_configs :
    each.databricks_config.name => each
  }

  scope                = azurerm_key_vault.databricks_key_vault[each.value.databricks_config.name].id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_databricks_access_connector.databricks_access_connector[each.value.databricks_config.name].identity[0].principal_id
}

module "access_connector_permissions_service_bus_rg_names" {
  source = "../naming"

  for_each = {
    for each in flatten([
      for databricks_config in local.databricks_configs : [
        for service_bus_config in databricks_config.databricks_config.access_connector_permissions.service_bus : {
          name                    = service_bus_config.name
          resource_group_name     = service_bus_config.resource_group_name
          resource_group_location = databricks_config.resource_group.location
        }
      ]
    ]) : "${each.resource_group_name}-${each.name}" => each
  }

  resource_type = "resource_group"
  env           = var.env
  location      = each.value.resource_group_location
  name          = each.value.resource_group_name
}

module "access_connector_permissions_service_bus_names" {
  source = "../naming"

  for_each = {
    for each in flatten([
      for databricks_config in local.databricks_configs : [
        for service_bus_config in databricks_config.databricks_config.access_connector_permissions.service_bus : {
          name                    = service_bus_config.name
          resource_group_name     = service_bus_config.resource_group_name
          resource_group_location = databricks_config.resource_group.location
        }
      ]
    ]) : "${each.resource_group_name}-${each.name}" => each
  }

  resource_type = "service_bus"
  env           = var.env
  location      = each.value.resource_group_location
  name          = each.value.name
}

data "azurerm_servicebus_namespace" "service_bus_namespaces" {
  for_each = {
    for each in flatten([
      for databricks_config in local.databricks_configs : [
        for service_bus_config in databricks_config.databricks_config.access_connector_permissions.service_bus : {
          name                = service_bus_config.name
          resource_group_name = service_bus_config.resource_group_name
        }
      ]
    ]) : "${each.resource_group_name}-${each.name}" => each
  }

  name                = module.access_connector_permissions_service_bus_names[each.key].name
  resource_group_name = module.access_connector_permissions_service_bus_rg_names[each.key].name
}

resource "azurerm_role_assignment" "service_bus_data_owner" {
  for_each = {
    for each in flatten([
      for databricks_config in local.databricks_configs : [
        for service_bus_config in databricks_config.databricks_config.access_connector_permissions.service_bus : {
          databricks_config   = databricks_config.databricks_config
          name                = service_bus_config.name
          resource_group_name = service_bus_config.resource_group_name
          role                = service_bus_config.role
        }
      ]
    ]) : "${each.resource_group_name}-${each.name}" => each
  }

  scope                = data.azurerm_servicebus_namespace.service_bus_namespaces[each.key].id
  role_definition_name = each.value.role
  principal_id         = azurerm_databricks_access_connector.databricks_access_connector[each.value.databricks_config.name].identity[0].principal_id
}

#TODO remove hardcoded values, use naming module & create storage module
data "azurerm_storage_account" "datalake" {
  count               = var.env != "shared" && !startswith(var.env, "o") ? 1 : 0 # ignore shared and online envs
  name                = "lhdatalakestorage${var.env}"
  resource_group_name = "rg-data-${var.env}"
}

data "azurerm_storage_account" "unity_catalog_managed" {
  count               = var.env != "shared" && !startswith(var.env, "o") ? 1 : 0 # ignore shared and online envs
  name                = "lhunitycatmanaged${var.env}"
  resource_group_name = "rg-data-${var.env}"
}

resource "azurerm_role_assignment" "databricks_storage_account_user" {
  for_each = {
    for idx, each in local.databricks_configs :
    each.databricks_config.name => each
    if var.env != "shared"
  }

  scope                = data.azurerm_storage_account.datalake[0].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.databricks_access_connector[each.value.databricks_config.name].identity[0].principal_id
}

module "role_definition_name_storage_list_keys" {
  for_each = {
    for idx, each in local.databricks_configs :
    each.databricks_config.name => each
    if var.env != "shared"
  }

  source = "../naming"

  resource_type = "role_definition"
  env           = var.env
  location      = each.value.resource_group.location
  name          = "storage_list_keys"
}

resource "azurerm_role_assignment" "databricks_unity_catalog_storage_account_user" {
  for_each = {
    for idx, each in local.databricks_configs :
    each.databricks_config.name => each
    if var.env != "shared"
  }

  scope                = data.azurerm_storage_account.unity_catalog_managed[0].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.databricks_access_connector[each.value.databricks_config.name].identity[0].principal_id
}

resource "azurerm_role_assignment" "unity_catalog_storage_account_user" {
  for_each = {
    for each in [
      "cad27880-1279-40e7-99fe-39e8995e4fb2" // sbox Databricks Access Connector principal_id. Cannot reference from shared sub dynamically
    ] :
    each => each
    if var.env == "shared"
  }

  scope                = azurerm_storage_account.storage_account["unitycatalogeus"].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "unity_catalog_storage_account_user_web_auth" {
  for_each = {
    for idx, each in local.databricks_configs :
    each.databricks_config.name => each
    if var.env == "shared"
  }

  scope                = azurerm_storage_account.storage_account["unitycatalogeus"].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.databricks_access_connector[each.value.databricks_config.name].identity[0].principal_id
}
