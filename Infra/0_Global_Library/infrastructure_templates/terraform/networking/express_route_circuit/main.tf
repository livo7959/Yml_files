resource "azurerm_express_route_circuit" "er_circuit" {
  name                  = var.circuit_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  service_provider_name = var.service_provider_name
  peering_location      = var.peering_location
  bandwidth_in_mbps     = var.bandwidth_in_mbps

  sku {
    tier   = var.express_route_sku.tier
    family = var.express_route_sku.family
  }
}
