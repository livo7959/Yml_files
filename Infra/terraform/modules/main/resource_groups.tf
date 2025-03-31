module "rg_names" {
  source = "../naming"

  for_each = {
    for rg_name, rg_config in var.resource_groups :
    rg_name => rg_config
  }

  env           = var.env
  location      = each.value.location
  resource_type = "resource_group"
  name          = each.key
}

resource "azurerm_resource_group" "resource_groups" {
  for_each = {
    for rg_name, rg_config in var.resource_groups :
    rg_name => rg_config
  }
  provider = azurerm
  name     = module.rg_names[each.key].name
  location = each.value.location
  tags     = local.common_tags
}
