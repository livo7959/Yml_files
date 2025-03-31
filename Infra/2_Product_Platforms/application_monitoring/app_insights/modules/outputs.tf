output "app_id" {
  value       = { for k, v in module.application_insights : k => v.app_id }
  description = " Resource id of application insights instances"
}

output "instrumentation_key" {
  value     = { for k, v in module.application_insights : k => v.instrumentation_key }
  sensitive = true
}

output "connection_string" {
  value     = { for k, v in module.application_insights : k => v.connection_string }
  sensitive = true
}
