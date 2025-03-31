output "data_collection_endpoint_name" {
  description = "Name of the data collection endpoint."
  value       = azurerm_monitor_data_collection_endpoint.this.name
}

output "data_collection_endpoint_id" {
  description = "Resource ID of the data collection endpoint."
  value       = azurerm_monitor_data_collection_endpoint.this.id
}
