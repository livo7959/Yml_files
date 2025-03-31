output "key_vault_id" {
  description = "Resource ID of the key vaults."
  value       = { for k, v in module.key_vaults_dev : k => v.id }
}

output "key_vault_name" {
  description = "Name of the key vaults."
  value       = { for k, v in module.key_vaults_dev : k => v.name }
}
