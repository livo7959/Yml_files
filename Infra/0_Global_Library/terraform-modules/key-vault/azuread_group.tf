# Create Azure AD reader and admin groups for direct assignment.
# Note we use Privileged Identity Management for Key Vault Admin access by users.

resource "azuread_group" "kv_reader" {
  display_name            = "lh-kv-${local.base_name}_kv_reader"
  owners                  = [data.azuread_client_config.current.object_id]
  security_enabled        = true
  description             = "Assigns Key Vault Reader and Secrets User roles to lh-kv-${local.base_name}"
  administrative_unit_ids = var.administrative_unit_ids
  members                 = length(local.combined_kv_reader_principal_ids) > 0 ? local.combined_kv_reader_principal_ids : []
}

resource "azuread_group" "kv_admin" {
  display_name            = "lh-kv-${local.base_name}_kv_admin"
  owners                  = [data.azuread_client_config.current.object_id]
  security_enabled        = true
  description             = "lh-kv-${local.base_name} key vault administrators"
  administrative_unit_ids = var.administrative_unit_ids
}
