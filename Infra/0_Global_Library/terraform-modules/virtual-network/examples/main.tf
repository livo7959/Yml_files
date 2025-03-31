provider "azurerm" {
  features {}
}

module "virtual_network" {
  source = "../"

  # Required variables
  name           = "foo"
  location       = "eus"
  environment    = "sbox"
  resource_group = "rg-foo"
  address_space  = ["10.0.0.0/8"]

  # Optional variables
  subnets = {
    "bar" : {
      address_prefix : "10.0.1.0/24"
    }
    "baz" : {
      address_prefix : "10.0.2.0/24"
    }
  }
  route_table = {} # An empty object will create a route table with the default route.
}
