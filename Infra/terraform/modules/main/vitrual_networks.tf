locals {
  private_dns_zone_virtual_network_links = flatten([
    for vnet_config in local.virtual_network_configs : [
      for private_dns_zone in vnet_config.virtual_network_config.private_dns_zones : {
        vnet_name        = vnet_config.virtual_network_config.name
        private_dns_zone = private_dns_zone
        rg_name          = vnet_config.resource_group.name
      }
    ]
  ])
  subnets = flatten([
    for vnet_config in local.virtual_network_configs : [
      for subnet_config in vnet_config.virtual_network_config.subnets : {
        vnet_name     = vnet_config.virtual_network_config.name
        subnet_config = subnet_config
        location      = vnet_config.resource_group.location
      }
    ]
  ])
}

module "vnet_name" {
  source = "../naming"

  for_each = {
    for idx, each in local.virtual_network_configs :
    each.virtual_network_config.name => each
  }

  resource_type = "virtual_network"
  env           = var.env
  location      = each.value.resource_group.location
  name          = each.value.virtual_network_config.name
}

resource "azurerm_virtual_network" "vnet" {
  for_each = {
    for idx, each in local.virtual_network_configs :
    each.virtual_network_config.name => each
  }

  name                = module.vnet_name[each.value.virtual_network_config.name].name
  location            = each.value.resource_group.location
  resource_group_name = each.value.resource_group.name
  address_space       = each.value.virtual_network_config.address_space[var.env]
  dns_servers         = each.value.virtual_network_config.dns_servers

  tags = local.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_virtual_network_link" {
  for_each = {
    for idx, private_dns_zone_virtual_network_link in local.private_dns_zone_virtual_network_links :
    idx => private_dns_zone_virtual_network_link
  }
  name                  = each.value.private_dns_zone
  resource_group_name   = each.value.rg_name
  private_dns_zone_name = each.value.private_dns_zone
  virtual_network_id    = azurerm_virtual_network.vnet[each.value.vnet_name].id
}

module "snet_name" {
  source = "../naming"

  for_each = {
    for idx, subnet in local.subnets :
    "${subnet.vnet_name}~${subnet.subnet_config.name}" => subnet
  }

  resource_type = "subnet"
  env           = var.env
  location      = each.value.location
  name          = each.value.subnet_config.name
}

resource "azurerm_subnet" "subnets" {
  for_each = {
    for idx, subnet in local.subnets :
    "${subnet.vnet_name}~${subnet.subnet_config.name}" => subnet
  }

  name                              = module.snet_name[each.key].name
  resource_group_name               = azurerm_virtual_network.vnet[each.value.vnet_name].resource_group_name
  virtual_network_name              = azurerm_virtual_network.vnet[each.value.vnet_name].name
  address_prefixes                  = [each.value.subnet_config.address_prefixes[var.env]]
  private_endpoint_network_policies = each.value.subnet_config.private_endpoint_network_policies
  service_endpoints                 = each.value.subnet_config.service_endpoints

  dynamic "delegation" {
    for_each = each.value.subnet_config.delegation
    content {
      name = "delegation"
      service_delegation {
        name    = delegation.value["name"]
        actions = delegation.value["actions"]
      }
    }
  }
}

resource "azurerm_subnet_nat_gateway_association" "subnet_nat_gateway_association" {
  for_each = {
    for idx, subnet in local.subnets :
    "${subnet.vnet_name}~${subnet.subnet_config.name}" => subnet.subnet_config.nat_gateway
    if subnet.subnet_config.nat_gateway != ""
  }

  subnet_id      = azurerm_subnet.subnets[each.key].id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway[each.value].id
}

resource "azurerm_subnet_network_security_group_association" "subnet_network_security_group_association" {
  for_each = {
    for idx, subnet in local.subnets :
    "${subnet.vnet_name}~${subnet.subnet_config.name}" => subnet.subnet_config.network_security_group
    if subnet.subnet_config.network_security_group != null
  }

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.network_security_group[each.value].id
}
