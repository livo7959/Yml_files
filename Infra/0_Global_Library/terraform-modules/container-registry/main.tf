resource "azurerm_container_registry" "this" {
  name                          = "lhcr${local.base_name}" # See README.md for more info on naming convention
  resource_group_name           = var.resource_group_name
  location                      = module.common_constants.region_short_name_to_long_name[var.location]
  sku                           = var.sku
  admin_enabled                 = var.admin_enabled
  public_network_access_enabled = var.public_network_access_enabled
  zone_redundancy_enabled       = var.zone_redundancy_enabled
  network_rule_bypass_option    = var.network_rule_bypass_option
  tags                          = local.merged_tags

  # If SKU is set to Premium (Georeplications is only supported with the Premium SKU) and var.geopreplications is not null - then iterate over var.georeplications. If not default to empty list []
  dynamic "georeplications" {
    for_each = var.sku == "Premium" && var.georeplications != null ? var.georeplications : []
    content {
      location                  = georeplications.value.location
      regional_endpoint_enabled = georeplications.value.regional_endpoint_enabled
      zone_redundancy_enabled   = georeplications.value.zone_redundancy_enabled
      tags                      = georeplications.value.tags
    }
  }

  # If SKU is set to Premium (network rule sets are only supported with the Premium SKU) and var.network_rule_set variable is not null - then iterate over var.network_rule_set. If not default to empty list []
  dynamic "network_rule_set" {
    for_each = var.sku == "Premium" && var.network_rule_set != null ? var.network_rule_set : []
    content {
      default_action = network_rule_set.value.default_action
      dynamic "ip_rule" {
        for_each = network_rule_set.value.ip_rule
        content {
          action   = ip_rule.value.action
          ip_range = ip_rule.value.ip_range
        }
      }
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? var.identity : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
}
