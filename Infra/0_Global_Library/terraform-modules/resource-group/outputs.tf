output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.this.name
}

output "resource_group_id" {
  description = "Resource group id"
  value       = azurerm_resource_group.this.id
}

output "resource_group_location" {
  description = "Resource group region"
  value       = azurerm_resource_group.this.location
}
