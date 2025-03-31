data "azuread_client_config" "current" {}

resource "azuread_group" "emergency_access_group" {
  display_name     = "CA_Emergency_Account_Exemption"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
  description      = "Emergency access group to be excluded from CA policies. Members are secured with non-phishable auth"
}

resource "azuread_group" "exemption_group" {
  for_each = { for key, value in local.ca_policies : key => value }

  display_name     = "${each.value.name}_Exemption"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
  description      = "${each.value.name} Exemption Group"
}

resource "azuread_group" "inclusion_group" {
  for_each = { for key, value in local.ca_policies : key => value if value.create_inclusion_group }

  display_name     = "${each.value.name}_Inclusion_Group"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
  description      = "${each.value.name} Inclusion Group"
}
