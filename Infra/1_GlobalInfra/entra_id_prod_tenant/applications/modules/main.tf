# We set the service principle owner to be itself. The purpose of this is that it acts as a
# reminder that this is managed by Terraform and to not make changes to it directly in the Azure
# web GUI.
data "azuread_client_config" "current" {}

resource "azuread_application" "this" {
  for_each = { for app in var.applications : app.name => app }

  display_name = each.value.name
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "this" {
  for_each = { for app in var.applications : app.name => app }

  client_id = azuread_application.this[each.key].client_id
  owners    = [data.azuread_client_config.current.object_id]
}
