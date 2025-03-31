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
    name                  = "workload"
    workload_profile_type = "D4"
    maximum_count         = 1
    minimum_count         = 1
  }
  tags = {
    environment = "sandbox"
  }
}

module "container_registry" {
  source                  = "../../../container-registry"
  name                    = "test"
  location                = "eus"
  environment             = "sbox"
  resource_group_name     = module.resource_group.resource_group_name
  sku                     = "Premium"
  zone_redundancy_enabled = true
  network_rule_set = [{
    default_action = "Allow"
  }]

  identity = [
    {
      type = "SystemAssigned"
    }
  ]
}

resource "azurerm_user_assigned_identity" "uai" {
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  name                = "uai-test"
}

resource "azurerm_role_assignment" "acr_pull_role" {
  scope                = module.container_registry.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.uai.principal_id
}

module "container_app" {
  source                       = "../../"
  name                         = "test"
  location                     = "eus"
  environment                  = "sbox"
  resource_group_name          = module.resource_group.resource_group_name
  container_app_environment_id = module.container_app_env.id
  workload_profile_name        = "workload"
  revision_mode                = "Multiple" # Ingress traffic weight
  template = {
    min_replicas    = 1
    max_replicas    = 5
    revision_suffix = "rev"
    container = [
      {
        name   = "test"
        image  = "mcr.microsoft.com/k8se/quickstart:latest" #"${module.container_registry.login_server}/nginx:rev2"
        cpu    = 0.25
        memory = "0.5Gi"

        liveness_probe = {
          transport = "HTTP"
          port      = 80
          header = {
            "testheader" = "test"
          }
        }
      }
    ]
    http_scale_rule = [
      {
        name                = "test-http-rule"
        concurrent_requests = 100
      }
    ]
    tags = {
      environment = "sandbox"
    }
  }
  identity = {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uai.id]
  }

  registry = {
    server   = module.container_registry.login_server
    identity = azurerm_user_assigned_identity.uai.id
  }

  ingress = {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 80
    transport                  = "auto"
    traffic_weight = [
      {
        label           = "latest"
        percentage      = 80
        latest_revision = true
      },
      {
        label           = "rev2" # image must be replaced via image tag in order for this to appear first in the portal
        percentage      = 20
        latest_revision = false
        revision_suffix = "rev"
      }

    ]
  }

}
