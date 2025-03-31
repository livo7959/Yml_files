resource "azurerm_key_vault" "this" {
  resource_group_name             = var.resource_group
  location                        = module.common_constants.region_short_name_to_long_name[var.location]
  name                            = "lh-kv-${local.base_name}"
  sku_name                        = var.sku_name
  tenant_id                       = coalesce(var.tenant_id, data.azurerm_client_config.current.tenant_id)
  purge_protection_enabled        = var.purge_protection_enabled
  public_network_access_enabled   = var.public_network_access_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = try(var.rbac_authorization_enabled, true)
  tags                            = local.merged_tags

  dynamic "network_acls" {
    for_each = var.network_acls != null ? var.network_acls : []
    content {
      bypass                     = network_acls.value.bypass
      default_action             = network_acls.value.default_action
      ip_rules                   = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }
}

resource "azurerm_management_lock" "this" {
  count = var.lock != null ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-lh-kv-${local.base_name}")
  scope      = azurerm_key_vault.this.id
}
