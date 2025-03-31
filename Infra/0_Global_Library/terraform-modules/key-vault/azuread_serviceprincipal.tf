# LogixHealth uses service principals to be used by on-premise workloads to retrieve vault secrets.
# The Entra ID role Application.ReadWrite.OwnedBy is required to create the service principals.check

resource "azuread_application" "this" {
  count = var.create_service_principal ? 1 : 0

  display_name = "sp-lh-kv-${local.base_name}"
  owners       = [data.azuread_client_config.current.object_id]
  notes        = "Service principal automated access to lh-kv-${local.base_name}"
}

resource "azuread_service_principal" "this" {
  count = var.create_service_principal ? 1 : 0

  client_id = one(azuread_application.this[*].client_id)
}
