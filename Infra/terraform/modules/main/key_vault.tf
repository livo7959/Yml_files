module "key_vault_name" {
  source = "../naming"

  for_each = {
    for each in local.key_vault_configs :
    each.key_vault_id => each
  }

  resource_type = "key_vault"
  env           = var.env
  location      = each.value.resource_group.location
  name          = each.value.key_vault_id
}

resource "azurerm_key_vault" "key_vault" {
  for_each = {
    for each in local.key_vault_configs :
    each.key_vault_id => each
  }

  name                       = module.key_vault_name[each.key].name
  location                   = each.value.resource_group.location
  resource_group_name        = each.value.resource_group.name
  tenant_id                  = data.azurerm_subscription.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  public_network_access_enabled   = true
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
  }

  tags = local.common_tags
}

resource "azurerm_key_vault_key" "keys" {
  for_each = {
    for each in flatten([
      for key_vault_config in local.key_vault_configs : [
        for key_config in key_vault_config.key_vault_config.keys : {
          key_config   = key_config
          key_vault_id = key_vault_config.key_vault_id
        }
      ]
    ]) : "${each.key_vault_id}-${each.key_config.key_name}" => each
  }

  name         = each.value.key_config.key_name
  key_vault_id = azurerm_key_vault.key_vault[each.value.key_vault_id].id
  key_type     = each.value.key_config.key_type
  key_size     = each.value.key_config.key_size
  key_opts     = each.value.key_config.key_opts
  curve        = each.value.key_config.curve
}
