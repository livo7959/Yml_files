
module "resource_group" {
  source              = "../../../../0_Global_Library/infrastructure_templates/terraform/resource_group"
  location            = "eastus"
  resource_group_name = "rg-kv-avd-001"
  tags = {
    environment = "prod"
    managedBy   = "terraform"
  }
}

module "key_vault_avd" {
  source                          = "../../../../0_Global_Library/infrastructure_templates/terraform/key_vault"
  resource_group_name             = module.resource_group.resource_group_name
  location                        = module.resource_group.resource_group_location
  name                            = "lh-kv-avd-prod"
  env                             = "prod"
  tags                            = { "environment" = "prod", "managedBy" = "Terraform" }
  rbac_authorization_enabled      = true
  sku_name                        = "standard"
  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false
  kv_admin_objects_ids            = ["9509c3b0-1a56-4de3-b0d8-a999836992f1"]
  kv_reader_objects_ids           = ["9eebe354-dd84-48ab-8ce5-784e48930912"]
  kv_secrets_user_objects_ids     = ["9eebe354-dd84-48ab-8ce5-784e48930912"]
  kv_certificate_user_objects_ids = []
  public_network_access_enabled   = true
  network_acls = [
    {
      bypass         = "None"
      default_action = "Deny"
      ip_rules       = ["66.97.189.250"]
    }
  ]
  purge_protection_enabled   = true
  soft_delete_retention_days = 7

}
