module "resource_group" {
  source      = "../../../resource-group"
  name        = "test"
  location    = "eus"
  environment = "sbox"
}

module "virtual_network" {
  source         = "../../../virtual-network"
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
  }
}

module "container_app_env" {
  source                   = "../../../container-app-environment"
  name                     = "test"
  location                 = "eus"
  environment              = "sbox"
  resource_group_name      = module.resource_group.resource_group_name
  infrastructure_subnet_id = module.virtual_network.subnet_id["bar"]
  workload_profile = {
    name                  = "test"
    workload_profile_type = "D4"
    maximum_count         = 1
    minimum_count         = 1
  }
  tags = {
    environment = "sandbox"
  }
}

module "container_app" {
  source                       = "../../"
  name                         = "test"
  location                     = "eus"
  environment                  = "sbox"
  resource_group_name          = module.resource_group.resource_group_name
  container_app_environment_id = module.container_app_env.id
  workload_profile_name        = "test"
  revision_mode                = "Single"
  template = {
    container = [
      {
        name  = "test"
        image = "mcr.microsoft.com/k8se/quickstart:latest"
        cpu   = 0.25
    memory = "0.5Gi" }]
    tags = {
      environment = "sandbox"
    }
  }
}
