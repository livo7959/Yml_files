module "nat_gateway_name" {
  source = "../naming"

  for_each = {
    for idx, each in local.nat_gateways :
    each.nat_gateway_name => each
  }

  resource_type = "nat_gateway"
  env           = var.env
  location      = each.value.resource_group.location
  name          = each.key
}

resource "azurerm_nat_gateway" "nat_gateway" {
  for_each = {
    for idx, each in local.nat_gateways :
    each.nat_gateway_name => each
  }

  name                    = module.nat_gateway_name[each.key].name
  resource_group_name     = each.value.resource_group.name
  location                = each.value.resource_group.location
  sku_name                = "Standard"
  idle_timeout_in_minutes = 4

  tags = local.common_tags
}

module "public_ip_name" {
  source = "../naming"

  for_each = {
    for idx, each in local.nat_gateways :
    each.nat_gateway_name => each
  }

  resource_type = "public_ip"
  env           = var.env
  location      = each.value.resource_group.location
  name          = module.nat_gateway_name[each.key].basename
}

resource "azurerm_public_ip" "public_ip" {
  for_each = {
    for idx, each in local.nat_gateways :
    each.nat_gateway_name => each
  }

  name                    = module.public_ip_name[each.key].name
  resource_group_name     = each.value.resource_group.name
  location                = each.value.resource_group.location
  allocation_method       = "Static"
  ddos_protection_mode    = "VirtualNetworkInherited"
  ip_version              = "IPv4"
  sku                     = "Standard"
  sku_tier                = "Regional"
  idle_timeout_in_minutes = 4
  zones = [
    "1",
    "2",
    "3"
  ]

  tags = local.common_tags
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gateway_public_ip_association" {
  for_each = {
    for idx, each in local.nat_gateways :
    each.nat_gateway_name => each
  }

  nat_gateway_id       = azurerm_nat_gateway.nat_gateway[each.key].id
  public_ip_address_id = azurerm_public_ip.public_ip[each.key].id
}
