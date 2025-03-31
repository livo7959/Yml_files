module "resource_group" {
  source      = "../../resource-group"
  name        = "test"
  location    = "eus"
  environment = "sbox"
}

module "container_registry_standard" {
  source              = "../"
  name                = "test"
  location            = "eus"
  environment         = "sbox"
  resource_group_name = module.resource_group.resource_group_name
  sku                 = "Standard"
  identity = [
    {
      type = "SystemAssigned"
    }
  ]

}
module "container_registry_premium" {
  source                  = "../"
  name                    = "testt"
  location                = "eus"
  environment             = "sbox"
  resource_group_name     = module.resource_group.resource_group_name
  sku                     = "Premium"
  zone_redundancy_enabled = true
  georeplications = [
    {
      location                = "eastus2"
      zone_redundancy_enabled = true
      tags = {
        tag1 = "test1"
        tag2 = "test2"
      }
    },
    {
      location                = "centralus"
      zone_redundancy_enabled = true
      tags = {
        tag1 = "test1"
        tag2 = "test2"
      }
    }
  ]
  network_rule_set = [{
    default_action = "Deny"
    ip_rule = [
      {
        action   = "Allow"
        ip_range = "66.97.189.250/32"
      },
      {
        action   = "Allow"
        ip_range = "8.8.8.8/32"
      }
    ]
  }]

  identity = [
    {
      type = "SystemAssigned"
    }
  ]

}
