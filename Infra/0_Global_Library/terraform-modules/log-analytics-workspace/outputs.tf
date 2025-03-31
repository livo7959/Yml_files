output "resource_id" {
  description = "Log Analytics resource ID"
  value       = azurerm_log_analytics_workspace.this.id
}

output "workspace_id" {
  description = "Log Analytics Workspace ID"
  value       = azurerm_log_analytics_workspace.this.workspace_id
}

