resource "azurerm_key_vault" "vault" {
  resource_group_name             = var.resource_group_name
  location                        = var.location
  name                            = var.name
  sku_name                        = var.sku_name
  tenant_id                       = var.tenant_id
  purge_protection_enabled        = var.purge_protection_enabled
  public_network_access_enabled   = var.public_network_access_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.rbac_authorization_enabled
  tags                            = var.tags

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

resource "azurerm_role_assignment" "rbac_keyvault_administrator" {
  for_each = toset(var.rbac_authorization_enabled ? var.kv_admin_objects_ids : [])

  scope                = one(azurerm_key_vault.vault[*].id)
  role_definition_name = "Key Vault Administrator"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "rbac_keyvault_secrets_users" {
  for_each = toset(var.rbac_authorization_enabled ? var.kv_reader_objects_ids : [])

  scope                = one(azurerm_key_vault.vault[*].id)
  role_definition_name = "Key Vault Secrets User"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "rbac_keyvault_reader" {
  for_each = toset(var.rbac_authorization_enabled ? var.kv_reader_objects_ids : [])

  scope                = one(azurerm_key_vault.vault[*].id)
  role_definition_name = "Key Vault Reader"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "rbac_keyvault_certificate_user" {
  for_each = toset(var.rbac_authorization_enabled ? var.kv_certificate_user_objects_ids : [])

  scope                = one(azurerm_key_vault.vault[*].id)
  role_definition_name = "Key Vault Certificate User"
  principal_id         = each.value
}
