output "id" {
  description = "The ID of the container registry"
  value       = azurerm_container_registry.this.id
}

output "login_server" {
  description = "The URL that can be used to log into the container registry"
  value       = azurerm_container_registry.this.login_server
}
