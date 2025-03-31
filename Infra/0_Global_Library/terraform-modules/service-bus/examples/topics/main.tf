module "resource_group" {
  source      = "../../../resource-group"
  name        = "testsbt"
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
  topics = {
    "testtopic1" = {
      max_size_in_megabytes = 5120

      subscriptions = {
        "testtopic1sub1" = {
          max_delivery_count = 5
          lock_duration      = "PT5M"
        }
        "testtopic1sub2" = {
          max_delivery_count = 3
          lock_duration      = "PT2M"
        }
      }
    },

    "testtopic2" = {
      max_size_in_megabytes = 1024

      subscriptions = {
        "testtopic2sub1" = {
          max_delivery_count = 3
        }
        "testtopic2sub2" = {
          max_delivery_count = 3
        }
      }
    }
  }
}
