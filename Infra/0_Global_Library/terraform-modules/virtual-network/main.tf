# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
resource "azurerm_virtual_network" "this" {
  name                = "vnet-${local.base_name}" # e.g. vnet-foo-eus-prod
  location            = module.common_constants.region_short_name_to_long_name[var.location]
  resource_group_name = var.resource_group
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = local.merged_tags
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                 = "snet-${local.base_name}-${each.key}"
  resource_group_name  = azurerm_virtual_network.this.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  # As of July 2024, while the upstream module accepts multiple prefixes, only a single address
  # prefix can actually be set. See:
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
  # https://github.com/Azure/azure-cli/issues/18194#issuecomment-880484269
  # Thus, we only allow a single string for the time being.
  address_prefixes                              = [each.value.address_prefix]
  service_endpoints                             = each.value.service_endpoints
  private_endpoint_network_policies             = each.value.private_endpoint_network_policies
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled

  dynamic "delegation" {
    for_each = each.value.delegation != null ? [each.value.delegation] : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.name
        actions = delegation.value.actions
      }
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
resource "azurerm_network_security_group" "this" {
  for_each = var.subnets

  name                = "nsg-${local.base_name}-${each.key}"
  resource_group_name = azurerm_virtual_network.this.resource_group_name
  location            = azurerm_virtual_network.this.location
  tags                = local.merged_tags

  dynamic "security_rule" {
    for_each = each.value.nsg_rules != null ? each.value.nsg_rules : []

    content {
      name                                       = security_rule.value.name
      priority                                   = security_rule.value.priority
      direction                                  = security_rule.value.direction
      access                                     = security_rule.value.access
      protocol                                   = security_rule.value.protocol
      source_port_range                          = try(security_rule.value.source_port_range, null)
      source_port_ranges                         = try(security_rule.value.source_port_ranges, null)
      destination_port_range                     = try(security_rule.value.destination_port_range, null)
      destination_port_ranges                    = try(security_rule.value.destination_port_ranges, null)
      source_address_prefix                      = try(security_rule.value.source_address_prefix, null)
      source_address_prefixes                    = try(security_rule.value.source_address_prefixes, null)
      destination_address_prefix                 = try(security_rule.value.destination_address_prefix, null)
      destination_address_prefixes               = try(security_rule.value.destination_address_prefixes, null)
      source_application_security_group_ids      = try(security_rule.value.source_application_security_group_ids, null)
      destination_application_security_group_ids = try(security_rule.value.destination_application_security_group_ids, null)
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association
resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = var.subnets

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}

# https://registry.terraform.io/providers/hashicorp/Azurerm/latest/docs/resources/route_table
resource "azurerm_route_table" "this" {
  count = local.deploy_route_table ? 1 : 0

  name                          = local.route_table_name
  resource_group_name           = azurerm_virtual_network.this.resource_group_name
  location                      = azurerm_virtual_network.this.location
  bgp_route_propagation_enabled = var.route_table.bgp_route_propagation_enabled
  tags                          = local.merged_tags

  dynamic "route" {
    for_each = local.routes

    content {
      name                   = route.key
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = try(route.value.next_hop_in_ip_address, null)
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/Azurerm/latest/docs/resources/subnet_route_table_association
resource "azurerm_subnet_route_table_association" "this" {
  for_each = local.deploy_route_table ? azurerm_subnet.this : {}

  subnet_id      = each.value.id
  route_table_id = azurerm_route_table.this[0].id
}

# https://registry.terraform.io/providers/hashicorp/Azurerm/latest/docs/resources/virtual_network_peering
resource "azurerm_virtual_network_peering" "this" {
  for_each = var.peerings

  name                      = "peer-to-${each.key}"
  resource_group_name       = var.resource_group
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = each.key

  # The following optional values inherit the defaults from the upstream module:
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering
  allow_virtual_network_access = try(each.value.allow_virtual_network_access, true)
  allow_forwarded_traffic      = try(each.value.allow_forwarded_traffic, false)
  allow_gateway_transit        = try(each.value.allow_gateway_transit, false)
  use_remote_gateways          = try(each.value.use_remote_gateways, false)
}
