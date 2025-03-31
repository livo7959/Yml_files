data "azurerm_subnet" "subnet" {
  name                 = "snet-inf-sandbox-eus-001"
  virtual_network_name = "vnet-inf-sandbox-eus-001"
  resource_group_name  = "rg-net-inf-sandbox"
}
module "resource_group" {
  source      = "../../../resource-group"
  name        = "testsbnsnrs"
  location    = "eus"
  environment = "sbox"
}

module "service_bus" {
  source                       = "../../"
  namespace_name               = "test"
  location                     = "eus"
  environment                  = "sbox"
  resource_group_name          = module.resource_group.resource_group_name
  sku                          = "Premium" # needed for network rules
  capacity                     = 1         # when sku is set to Premium
  premium_messaging_partitions = 1         # when sku is set to Premium
  tags = {
    environment = "sandbox"
  }
  # while testing to sandbox, needed to add Microsoft.ServiceBus to Service Endpoints in snet-inf-sandbox-eus-001 subnet
  network_rule_set = {
    default = {

      default_action                = "Deny"
      public_network_access_enabled = true
      trusted_services_allowed      = true
      ip_rules                      = ["10.135.0.0/24"]
      network_rules = {
        subnet_id                            = data.azurerm_subnet.subnet.id
        ignore_missing_vnet_service_endpoint = false
      }
    }
  }
}
