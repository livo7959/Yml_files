module "role_definition_name" {
  source = "../naming"

  for_each = {
    for idx, each in local.role_definition_configs :
    each.role_definition_config.name => each
  }

  resource_type = "role_definition"
  env           = var.env
  location      = each.value.resource_group.location
  name          = each.key
}

resource "azurerm_role_definition" "role_definition" {
  for_each = {
    for idx, each in local.role_definition_configs :
    each.role_definition_config.name => each
  }

  name        = module.role_definition_name[each.key].name
  scope       = data.azurerm_subscription.current.id
  description = each.value.role_definition_config.description
  permissions {
    actions          = each.value.role_definition_config.actions
    data_actions     = each.value.role_definition_config.data_actions
    not_actions      = each.value.role_definition_config.not_actions
    not_data_actions = each.value.role_definition_config.not_data_actions
  }
}
