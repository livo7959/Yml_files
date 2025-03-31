output "log_analytics_workspace_id" {
  value       = module.log_analytics_workspace.workspace_id
  description = "Log analytics workspace ID"
}

output "data_collection_endpoint_id" {
  value       = module.data_collection_endpoint.data_collection_endpoint_id
  description = "Data collection endpoint ID"
}
