module "storage_account_name" {
  source = "../naming"

  for_each = {
    for idx, each in local.storage_account_configs :
    each.storage_account_config.name => each
  }

  resource_type = "storage_account"
  env           = var.env
  location      = each.value.resource_group.location
  name          = each.key
}

resource "azurerm_storage_account" "storage_account" {
  for_each = {
    for idx, each in local.storage_account_configs :
    each.storage_account_config.name => each
  }

  name                          = module.storage_account_name[each.key].name
  resource_group_name           = each.value.resource_group.name
  location                      = each.value.resource_group.location
  account_kind                  = each.value.storage_account_config.account_kind
  account_tier                  = each.value.storage_account_config.account_tier
  account_replication_type      = each.value.storage_account_config.account_replication_type
  access_tier                   = each.value.storage_account_config.access_tier
  public_network_access_enabled = each.value.storage_account_config.public_network_access_enabled || each.value.storage_account_config.public_network_access_vnet_ip
  is_hns_enabled                = each.value.storage_account_config.hns_enabled
  sftp_enabled                  = each.value.storage_account_config.sftp_enabled

  allow_nested_items_to_be_public  = each.value.storage_account_config.allow_nested_items_to_be_public
  cross_tenant_replication_enabled = false
  https_traffic_only_enabled       = true
  min_tls_version                  = "TLS1_2"
  shared_access_key_enabled        = true

  dynamic "network_rules" {
    for_each = each.value.storage_account_config.public_network_access_vnet_ip == true ? [1] : []
    content {
      bypass         = each.value.storage_account_config.bypass
      default_action = "Deny"
      ip_rules = [
        "66.97.189.250",
        "20.121.254.164"
      ]
      virtual_network_subnet_ids = [
        for vnet_access_config in each.value.storage_account_config.vnet_access :
        "/subscriptions/${coalesce(vnet_access_config.subscription_id, data.azurerm_subscription.current.subscription_id)}/resourceGroups/${vnet_access_config.subscription_id == null ? vnet_access_config.resource_group_name == null ? each.value.resource_group.name : format("%s-%s", vnet_access_config.resource_group_name, var.env) : coalesce(vnet_access_config.resource_group_name, each.value.resource_group.name)}/providers/Microsoft.Network/virtualNetworks/${vnet_access_config.subscription_id == null ? format("%s-%s", vnet_access_config.virtual_network, var.env) : vnet_access_config.virtual_network}/subnets/${vnet_access_config.subscription_id == null ? format("%s-%s", vnet_access_config.subnet, var.env) : vnet_access_config.subnet}"
      ]
      dynamic "private_link_access" {
        for_each = each.value.storage_account_config.private_link_access
        content {
          endpoint_resource_id = private_link_access.value
        }
      }
    }
  }

  blob_properties {
    dynamic "cors_rule" {
      for_each = each.value.storage_account_config.cors_rule
      content {
        allowed_origins    = cors_rule.value.allowed_origins
        allowed_methods    = cors_rule.value.allowed_methods
        allowed_headers    = cors_rule.value.allowed_headers
        exposed_headers    = cors_rule.value.exposed_headers
        max_age_in_seconds = cors_rule.value.max_age_in_seconds
      }
    }
  }

  routing {
    choice = "MicrosoftRouting"
  }

  tags = local.common_tags
}

locals {
  storage_containers = flatten([
    for idx, storage_account_config in local.storage_account_configs : [
      for storage_container_config in storage_account_config.storage_account_config.containers : {
        storage_account_name     = azurerm_storage_account.storage_account[storage_account_config.storage_account_config.name].name
        storage_container_config = storage_container_config
    }]
  ])
}

resource "azurerm_storage_container" "storage_container" {
  for_each = {
    for idx, each in local.storage_containers :
    "${each.storage_account_name}~${each.storage_container_config.name}" => each
  }

  name                  = each.value.storage_container_config.name
  storage_account_name  = each.value.storage_account_name
  container_access_type = each.value.storage_container_config.container_access_type
}
