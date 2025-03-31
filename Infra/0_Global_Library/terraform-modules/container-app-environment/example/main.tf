module "resource_group" {
  source      = "../../resource-group"
  name        = "container"
  location    = "eus"
  environment = "sbox"
}

module "virtual_network" {
  source         = "../../virtual-network"
  name           = "test"
  location       = "eus"
  environment    = "sbox"
  resource_group = module.resource_group.resource_group_name
  address_space  = ["10.0.0.0/20"]
  subnets = {
    "bar" : {
      address_prefix = "10.0.0.0/21"
      delegation = {
        name    = "Microsoft.App/environments"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    }
    "baz" : {
      address_prefix = "10.0.8.0/21"
      delegation = {
        name    = "Microsoft.App/environments"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    }
  }
  route_table = {} # An empty object will create a route table with the default route.
}


module "container_apps_env" {
  source                   = "../"
  name                     = "test"
  location                 = "eus"
  environment              = "sbox"
  resource_group_name      = module.resource_group.resource_group_name
  infrastructure_subnet_id = module.virtual_network.subnet_id["bar"] # Subnet must have a /21 or larger address space
  workload_profile = {
    name                  = "workload"
    workload_profile_type = "D4"
    maximum_count         = 1
    minimum_count         = 1
  }
  tags = {
    environment = "sandbox"
  }
}

