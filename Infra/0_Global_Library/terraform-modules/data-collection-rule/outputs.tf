output "data_collection_rule_id" {
  description = "The resource ID of the data collection rule."
  value       = azurerm_monitor_data_collection_rule.this.id
}

output "data_collection_rule_name" {
  description = "The name of the data collection rule."
  value       = azurerm_monitor_data_collection_rule.this.name
}
