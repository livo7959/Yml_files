output "express_route_circuit_peering_id" {
  value = azurerm_express_route_circuit_peering.ercp["AzurePrivatePeering"].id
}

output "public_ip_id" {
  value = azurerm_public_ip.pip.id
}

output "virtual_network_gateway_id" {
  value = azurerm_virtual_network_gateway.ervngw.id
}

/*
output "express_route_connection_id" {
  value = azurerm_express_route_connection.er_connection.id
}
*/
