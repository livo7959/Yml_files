resource "azurerm_role_assignment" "rbac_kv_admin" {

  scope                = one(azurerm_key_vault.this[*].id)
  role_definition_name = "Key Vault Administrator"
  principal_id         = azuread_group.kv_admin.object_id
}

resource "azurerm_role_assignment" "rbac_kv_reader" {

  scope                = one(azurerm_key_vault.this[*].id)
  role_definition_name = "Key Vault Reader"
  principal_id         = azuread_group.kv_reader.object_id
}

resource "azurerm_role_assignment" "rbac_kv_secrets_user" {

  scope                = one(azurerm_key_vault.this[*].id)
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_group.kv_reader.object_id
}

resource "azurerm_pim_eligible_role_assignment" "pim_kv_admin" {
  for_each = length(local.kv_admin_principal_ids) > 0 ? local.kv_admin_principal_ids : []

  scope              = one(azurerm_key_vault.this[*].id)
  role_definition_id = data.azurerm_role_definition.kv_admin.role_definition_id
  principal_id       = each.value
  justification      = "Managing secrets for lh-kv-${local.base_name}"

  schedule {
    expiration {
      # Duration hours and end date time are available as well. LogixHealth defaults to duration in days as only one can be specified.
      duration_days = try(var.pim_eligibility_duration_days, 365)
    }
  }
}
