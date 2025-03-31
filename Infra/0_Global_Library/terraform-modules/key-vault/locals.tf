module "common_constants" {
  source = "../common/constants"
}

locals {
  base_name   = "${var.name}-${var.location}-${var.environment}"
  merged_tags = merge(module.common_constants.default_tags, var.tags)

  # Flatten the list of the principal (object) IDs designated for assignment.
  kv_reader_principal_ids = flatten([var.kv_reader_member_object_ids])

  kv_admin_principal_ids = toset(coalesce(var.pim_assignments.kv_admin_pim_eligible_object_ids, []))

  # If service principal and kv reader user assignment principal (object) IDs are passed, combine
  # them for member assignment.
  combined_kv_reader_principal_ids = var.create_service_principal ? concat(
    local.kv_reader_principal_ids, [one(azuread_service_principal.this[*].object_id
  )]) : local.kv_reader_principal_ids
}
