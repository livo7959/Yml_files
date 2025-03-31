data "azuread_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "rg-kv-mod-test-sbox"
  location = "eastus"
}

module "key_vault_example" {
  source                        = "../../"
  resource_group                = azurerm_resource_group.rg.name
  location                      = "eus"
  name                          = "modtest"
  environment                   = "sbox"
  rbac_authorization_enabled    = true
  public_network_access_enabled = true
  create_service_principal      = true
  sku_name                      = "standard"
  network_acls = [
    {
      bypass         = "None"
      default_action = "Deny"
      ip_rules       = ["66.97.189.250"]
    }
  ]
}

module "key_vault_vtwo" {
  source                        = "../../"
  resource_group                = azurerm_resource_group.rg.name
  location                      = "eus"
  name                          = "modvtwo"
  environment                   = "sbox"
  rbac_authorization_enabled    = true
  public_network_access_enabled = true
  create_service_principal      = true
  sku_name                      = "standard"
  network_acls = [
    {
      bypass         = "None"
      default_action = "Deny"
      ip_rules       = ["66.97.189.250"]
    }
  ]
  tags = {
    owner = "app-devs"
  }
  kv_reader_member_object_ids = [
    "b26d3edd-673c-4988-b46a-d75adf14678e",
    "3c1d9b29-acde-414b-9fac-650d83007608",
  ]
  pim_assignments = {
    kv_admin_pim_eligible_object_ids = [
      "b26d3edd-673c-4988-b46a-d75adf14678e",
      "f8ea2391-c074-4d67-8184-3f3fbf00360f",
    ]
  }
}

module "key_vault_vthree" {
  source                        = "../../"
  resource_group                = azurerm_resource_group.rg.name
  location                      = "eus"
  name                          = "modvthree"
  environment                   = "sbox"
  rbac_authorization_enabled    = true
  public_network_access_enabled = true
  create_service_principal      = true
  sku_name                      = "standard"
  network_acls = [
    {
      bypass         = "None"
      default_action = "Deny"
      ip_rules       = ["66.97.189.250"]
    }
  ]
  tags = {
    owner = "app-devs"
  }
  kv_reader_member_object_ids = [
    "b26d3edd-673c-4988-b46a-d75adf14678e",
    "3c1d9b29-acde-414b-9fac-650d83007608",
    "2d41b3b4-a31f-490b-b4b1-107a9b6e4b0f",
  ]
  pim_assignments = {
    kv_admin_pim_eligible_object_ids = [
      "b26d3edd-673c-4988-b46a-d75adf14678e",
      "2d41b3b4-a31f-490b-b4b1-107a9b6e4b0f",
    ]
  }
}
