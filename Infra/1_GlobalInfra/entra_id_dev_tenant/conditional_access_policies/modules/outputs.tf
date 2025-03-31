output "emergency_access_group_id" {
  description = "The object ID of the emergency access group"
  value       = azuread_group.emergency_access_group.object_id
}

output "exemption_group_ids" {
  description = "The object IDs of exemption groups"
  value       = { for k, v in azuread_group.exemption_group : k => v.object_id }
}

output "inclusion_group_ids" {
  description = "The object IDs of exemption groups"
  value       = { for k, v in azuread_group.inclusion_group : k => v.object_id }
}

output "internal_user_supported_mfa_id" {
  description = "Object ID of the Authentication Policy Strength"
  value       = azuread_authentication_strength_policy.internal_user_supported_mfa.id
}
