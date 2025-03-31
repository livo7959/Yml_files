data "azurerm_subnet" "gw_subnet" {
  name                 = "GatewaySubnet"
  virtual_network_name = "vnet-hub-eus-001"
  resource_group_name  = "rg-net-hub-001"
}

data "azurerm_resource_group" "rg_net_hub_001" {
  name = "rg-net-hub-001"
}

module "resource_group" {
  source              = "../../../../0_Global_Library/infrastructure_templates/terraform/resource_group"
  resource_group_name = "rg-expressroute-hub-eus"
  location            = "eastus"
  tags = {
    environment = "prod"
    managedBy   = "terraform"
  }
}

module "express_route_circuit" {
  source              = "../../../../0_Global_Library/infrastructure_templates/terraform/networking/express_route_circuit"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  circuit_name        = "erc-hub-eus-001"
  bandwidth_in_mbps   = 5000
  express_route_sku = {
    tier   = "Standard"
    family = "MeteredData"
  }
  service_provider_name = "Crown Castle"
  peering_location      = "Washington DC"
}

resource "azurerm_public_ip" "pip" {
  name                = var.public_ip_name
  location            = module.resource_group.resource_group_location
  resource_group_name = data.azurerm_resource_group.rg_net_hub_001.name
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
}

resource "azurerm_virtual_network_gateway" "ervngw" {
  name                = var.gateway_name
  location            = module.resource_group.resource_group_location
  resource_group_name = data.azurerm_resource_group.rg_net_hub_001.name

  type     = var.gateway_type
  vpn_type = var.vpn_type
  sku      = var.gateway_sku

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.azurerm_subnet.gw_subnet.id
  }
}

resource "azurerm_express_route_circuit_peering" "ercp" {
  for_each = var.express_route_circuit_peering_enabled ? { for peering in var.express_route_circuit_peerings : peering.peering_type => peering } : {}

  express_route_circuit_name = module.express_route_circuit.name
  resource_group_name        = module.resource_group.resource_group_name

  peering_type                  = each.value.peering_type
  primary_peer_address_prefix   = each.value.primary_peer_address_prefix
  secondary_peer_address_prefix = each.value.secondary_peer_address_prefix
  peer_asn                      = each.value.peer_asn
  vlan_id                       = each.value.vlan_id
  shared_key                    = each.value.shared_key
}

resource "azurerm_virtual_network_gateway_connection" "er_connection" {
  name                = "cn-${azurerm_virtual_network_gateway.ervngw.name}"
  location            = module.resource_group.resource_group_location
  resource_group_name = data.azurerm_resource_group.rg_net_hub_001.name

  type                       = "ExpressRoute"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.ervngw.id
  express_route_circuit_id   = module.express_route_circuit.id
  routing_weight             = var.routing_weight
}
