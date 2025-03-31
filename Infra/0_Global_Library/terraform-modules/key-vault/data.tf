data "azuread_client_config" "current" {}

data "azurerm_client_config" "current" {}

data "azurerm_role_definition" "kv_admin" {
  name  = "Key Vault Administrator"
  scope = azurerm_key_vault.this.id
}
