output "app_id" {
  value = module.application_insights.app_id
}

output "instrumentation_key" {
  value     = module.application_insights.instrumentation_key
  sensitive = true
}

output "connection_string" {
  value     = module.application_insights.connection_string
  sensitive = true
}
