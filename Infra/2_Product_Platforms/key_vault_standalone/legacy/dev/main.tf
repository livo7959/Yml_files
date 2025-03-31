module "rg_kv_standalone_dev" {
  source              = "../../../../0_Global_Library/infrastructure_templates/terraform/resource_group"
  location            = "eastus"
  resource_group_name = "rg-kv-standalone-dev"
  tags = {
    environment = "dev"
    managedBy   = "terraform"
  }
}

module "key_vaults_dev" {
  source   = "../../../../0_Global_Library/infrastructure_templates/terraform/key_vault"
  for_each = { for kv in var.key_vaults_dev : kv.name => kv }

  env                             = each.value.env
  tags                            = each.value.tags
  resource_group_name             = module.rg_kv_standalone_dev.resource_group_name
  location                        = module.rg_kv_standalone_dev.resource_group_location
  name                            = each.value.name
  sku_name                        = each.value.sku_name
  enabled_for_deployment          = each.value.enabled_for_deployment
  enabled_for_disk_encryption     = each.value.enabled_for_disk_encryption
  enabled_for_template_deployment = each.value.enabled_for_template_deployment
  kv_admin_objects_ids            = each.value.kv_admin_objects_ids
  kv_reader_objects_ids           = each.value.kv_reader_objects_ids
  kv_secrets_user_objects_ids     = each.value.kv_secrets_user_objects_ids
  kv_certificate_user_objects_ids = each.value.kv_certificate_user_objects_ids
  public_network_access_enabled   = each.value.public_network_access_enabled
  network_acls                    = each.value.network_acls
  purge_protection_enabled        = each.value.purge_protection_enabled
  soft_delete_retention_days      = each.value.soft_delete_retention_days
  rbac_authorization_enabled      = each.value.rbac_authorization_enabled
}
