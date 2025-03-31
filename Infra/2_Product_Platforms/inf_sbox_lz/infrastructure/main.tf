module "resource_group_mod" {
  source              = "../../../0_Global_Library/infrastructure_templates/terraform/resource_group"
  resource_group_name = "rg-workload-sbox-eus"
  location            = "eastus"
  tags = {
    environment = "sbox"
    managedBy   = "terraform"
  }
}

module "vnet" {
  source = "../../../0_Global_Library/infrastructure_templates/terraform/networking/virtual_network"

  resource_group_name = module.resource_group_mod.resource_group_name
  location            = module.resource_group_mod.resource_group_location
  env                 = "sbox"
  name                = "vnet-workload-sbox-eus"
  address_space       = ["10.130.20.0/24"]
  subnets = {
    subnet1 = {
      name             = "snet-workload-eus-001"
      address_prefixes = ["10.130.20.0/26"]
    }
    subnet2 = {
      name             = "snet-workload-eus-001"
      address_prefixes = ["10.130.20.64/26"]
    }
  }
  nsg_name = "nsg-workload-sbox-eus"
  security_rules = {
    security_rule_1 = {
      name                       = "https-inbound-allow"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      destination_port_range     = "443"
      source_address_prefix      = "10.120.32.0/24"
      destination_address_prefix = "*"
    }
  }
  tags = {
    environment = "sbox"
    managedBy   = "terraform"
  }
  deploy_route_table            = true
  route_table_name              = "rt-workload-sbox-eus"
  disable_bgp_route_propagation = true
  routes = {
    azfw = {
      name                   = "udr-azfw"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.120.0.68"
    }
    private_enpoint = {
      name                   = "udr-private-endpoint"
      address_prefix         = "10.120.16.0/22"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.120.0.68"
    }
  }
}

module "peer_spoke_to_hub" {
  source               = "../../../0_Global_Library/infrastructure_templates/terraform/networking/virtual_network_peering"
  resource_group_name  = module.resource_group_mod.resource_group_name
  virtual_network_name = module.vnet.virtual_network_name
  peerings = [
    {
      name                         = "peer-to-${local.hub_virtual_network_name}"
      remote_virtual_network_id    = local.hub_virtual_network_id
      allow_virtual_network_access = true
      allow_forwarded_traffic      = false
      allow_gateway_transit        = false
      use_remote_gateways          = false
    }
  ]
}

module "peer_hub_to_spoke" {
  source               = "../../../0_Global_Library/infrastructure_templates/terraform/networking/virtual_network_peering"
  resource_group_name  = local.hub_resource_group_name
  virtual_network_name = local.hub_virtual_network_name
  peerings = [
    {
      name                         = "peer-to-${module.vnet.virtual_network_name}"
      remote_virtual_network_id    = module.vnet.virtual_network_id
      allow_virtual_network_access = true
      allow_forwarded_traffic      = false
      allow_gateway_transit        = false
      use_remote_gateways          = false
    }
  ]
}

