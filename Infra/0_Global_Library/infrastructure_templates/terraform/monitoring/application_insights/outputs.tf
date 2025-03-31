output "app_id" {
  value       = azurerm_application_insights.application_insights.app_id
  description = "App ID associated with this Application Insights component"
}

output "id" {
  value       = azurerm_application_insights.application_insights.id
  description = "ID of the Application Insights component"
}
output "instrumentation_key" {
  value       = azurerm_application_insights.application_insights.instrumentation_key
  description = "Instrumentation key for application insights"
  sensitive   = true
}

output "connection_string" {
  value       = azurerm_application_insights.application_insights.connection_string
  description = "Connection string for application insights"
  sensitive   = true
}
output "web_test_id" {
  value       = [for i, web_test in azurerm_application_insights_standard_web_test.this : web_test.id]
  description = "ID of the web test"
}
