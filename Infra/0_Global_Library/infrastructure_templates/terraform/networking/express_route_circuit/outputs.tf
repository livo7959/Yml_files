output "id" {
  description = "Express Route Circuit ID"
  value       = azurerm_express_route_circuit.er_circuit.id
}

output "service_key" {
  description = "The string needed by the service provider to provision the ExpressRoute circuit."
  value       = azurerm_express_route_circuit.er_circuit.service_key
  sensitive   = true
}

output "service_provider_provisioning_state" {
  description = "The ExpressRoute circuit provisioning state from your chosen service provider."
  value       = azurerm_express_route_circuit.er_circuit.service_provider_provisioning_state
}

output "resource_group_name" {
  description = "The Express Route circuit resource group name."
  value       = var.resource_group_name
}

output "name" {
  description = "Name of the Express Route Circuit."
  value       = azurerm_express_route_circuit.er_circuit.name
}
