output "applications_info" {
  description = "Information of the applications"
  value       = { for app in azuread_application.this : app.display_name => { client_id = app.client_id, display_name = app.display_name } }
}

output "app_scope_id" {
  description = "Output the entire app_scope_id map"
  value       = { for k, v in random_uuid.app_scope_id : k => v.result }
}
