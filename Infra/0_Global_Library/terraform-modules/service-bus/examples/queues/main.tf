module "resource_group" {
  source      = "../../../resource-group"
  name        = "testsbq"
  location    = "eus"
  environment = "sbox"
}

module "service_bus" {
  source              = "../../"
  namespace_name      = "test"
  location            = "eus"
  environment         = "sbox"
  resource_group_name = module.resource_group.resource_group_name
  tags = {
    environment = "sandbox"
  }
  queues = {
    "testqueue1" = {
      partitioning_enabled  = true
      lock_duration         = "PT2M"
      max_size_in_megabytes = 5120
    },
    "testqueue2" = {
      partitioning_enabled = false
      max_delivery_count   = 15
    }
  }
}
