resource "azurerm_route_table" "route_table" {
  name                          = var.route_table_name.name
  resource_group_name           = var.resource_group_name
  location                      = var.resource_group_name.location
  disable_bgp_route_propagation = var.disable_bgp_route_propagation
  dynamic "route" {
    for_each = var.routes
    content {
      name                   = each.value.name
      address_prefix         = each.value.address_prefix
      next_hop_type          = each.value.next_hop_type
      next_hop_in_ip_address = try(each.value.next_hop_in_ip_address, null)
    }
  }
}
