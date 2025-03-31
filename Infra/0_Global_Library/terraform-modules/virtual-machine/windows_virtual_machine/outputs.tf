output "id" {
  description = "ID of the Virtual Machine"
  value       = azurerm_windows_virtual_machine.this.id
}

output "virtual_machine_id" {
  description = "128-bit identifier which uniquely identifies this Virtual Machine"
  value       = azurerm_windows_virtual_machine.this.virtual_machine_id
}

output "virtual_machine_name" {
  description = "Name of the Virtual Machine"
  value       = azurerm_windows_virtual_machine.this.name
}
