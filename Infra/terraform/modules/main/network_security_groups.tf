module "nsg_name" {
  source = "../naming"

  for_each = {
    for idx, each in local.nsg_configs :
    each.network_security_group.name => each
  }

  resource_type = "network_security_group"
  env           = var.env
  location      = each.value.resource_group.location
  name          = each.value.network_security_group.name
}

resource "azurerm_network_security_group" "network_security_group" {
  for_each = {
    for idx, each in local.nsg_configs :
    each.network_security_group.name => each
  }

  name                = module.nsg_name[each.key].name
  location            = each.value.resource_group.location
  resource_group_name = each.value.resource_group.name

  dynamic "security_rule" {
    for_each = each.value.network_security_group.security_rules

    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
      description                = security_rule.value.description
    }
  }

  tags = local.common_tags
}
