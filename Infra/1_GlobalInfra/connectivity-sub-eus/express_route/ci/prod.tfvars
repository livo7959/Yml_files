/*
Variable inputs for the ExpressRoute deployment.
Note this doesn't contain the inputs for the ExpressRoute Circuit that is calling this module:
0_Global_Library/infrastructure_templates/terraform/networking/express_route_circuit
The inputs are defined in the main.tf file.
*/

public_ip_name = "pip-ergw-hub-eus-001"

public_ip_sku = "Standard"

public_ip_allocation_method = "Static"

public_ip_zones = [1, 2, 3]

gateway_name = "ergw-hub-eus-001"

gateway_type = "ExpressRoute"

vpn_type = "RouteBased"

gateway_sku = "ErGw1AZ"

routing_weight = 0

express_route_circuit_peerings = [
  {
    peering_type                  = "AzurePrivatePeering"
    primary_peer_address_prefix   = "172.19.70.0/30"
    secondary_peer_address_prefix = "172.19.70.4/30"
    peer_asn                      = 64570
    vlan_id                       = 70
  }
]

express_route_circuit_peering_enabled = true
