output "private_endpoint_id" {
  description = "Resource ID of the private endpoint."
  value       = { for k, v in azurerm_private_endpoint.private_endpoint : k => v.id }
}

output "private_endpoint_name" {
  description = "Name of the private endpoint."
  value       = { for k, v in azurerm_private_endpoint.private_endpoint : k => v.name }
}
