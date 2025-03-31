data "azurerm_resource_group" "rg" {
  name = "rg-kv-mod-test-sbox"
}

data "azuread_client_config" "current" {}

module "key_vault_loop_example" {
  source = "../../"

  for_each = { for kv in var.key_vaults : kv.name => kv }

  resource_group                  = data.azurerm_resource_group.rg.name
  name                            = each.value.name
  location                        = each.value.location
  environment                     = each.value.environment
  tenant_id                       = each.value.tenant_id
  sku_name                        = each.value.sku_name
  enabled_for_deployment          = each.value.enabled_for_deployment
  enabled_for_disk_encryption     = each.value.enabled_for_disk_encryption
  enabled_for_template_deployment = each.value.enabled_for_template_deployment
  public_network_access_enabled   = each.value.public_network_access_enabled
  purge_protection_enabled        = each.value.purge_protection_enabled
  soft_delete_retention_days      = each.value.soft_delete_retention_days
  rbac_authorization_enabled      = each.value.rbac_authorization_enabled
  administrative_unit_ids         = each.value.administrative_unit_ids
  kv_reader_member_object_ids     = each.value.kv_reader_member_object_ids
  pim_assignments                 = each.value.pim_assignments
  pim_eligibility_duration_days   = each.value.pim_eligibility_duration_days
  create_service_principal        = each.value.create_service_principal
  network_acls                    = each.value.network_acls
  tags                            = each.value.tags
  lock                            = each.value.lock
}
