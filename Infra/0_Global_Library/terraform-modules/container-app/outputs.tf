output "id" {
  description = "The ID of the Container App"
  value       = azurerm_container_app.this.id
}

output "latest_revision_name" {
  description = "The name of the latest Container Revision"
  value       = azurerm_container_app.this.latest_revision_name
}

output "latest_revision_fqdn" {
  description = "The FQDN of the latest revision of the Container App"
  value       = azurerm_container_app.this.latest_revision_fqdn
}
