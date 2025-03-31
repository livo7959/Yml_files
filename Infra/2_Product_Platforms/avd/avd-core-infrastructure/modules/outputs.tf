output "name" {
  description = "Name of the Key Vault"
  value       = module.key_vault_avd.name
}

output "id" {
  description = "Resource ID of the Key Vault"
  value       = module.key_vault_avd.id
}
