output "nsg_name" {
  description = "Network security group name"
  value       = azurerm_network_security_group.nsg.name
}

output "nsg_id" {
  description = "Network security group id"
  value       = azurerm_network_security_group.nsg.id
}
