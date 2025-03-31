module "resource_group" {
  source              = "../../resource_group"
  location            = "eastus"
  resource_group_name = "rg-kv-test-001"
}

module "key_vault_example" {
  source                        = "../"
  resource_group_name           = module.resource_group.resource_group_name
  location                      = module.resource_group.resource_group_location
  name                          = "kv-test-001"
  env                           = "sbox"
  rbac_authorization_enabled    = true
  public_network_access_enabled = true
  network_acls = [
    {
      bypass         = "None"
      default_action = "Deny"
      ip_rules       = ["66.97.189.250"]
    }
  ]

  kv_data_access_admin_objects_ids = ["Entra ID group object id"]
}
