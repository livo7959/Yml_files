output "name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.vault.name
}

output "id" {
  description = "Resource ID of the Key Vault"
  value       = azurerm_key_vault.vault.id
}
