module "resource-group" {
  source      = "../../resource-group"
  name        = "test"
  location    = "eus"
  environment = "sbox"
}

module "log-analytics-workspace" {
  source              = "../"
  name                = "test"
  location            = "eus"
  environment         = "sbox"
  resource_group_name = module.resource-group.resource_group_name
  tags = {
    environment = "sandbox"
  }
}
