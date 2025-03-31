provider "azurerm" {
  features {}
}

module "resource-group" {
  source = "../"

  # Required variables
  name        = "foo"
  location    = "eus"
  environment = "sbox"
}

module "resource-group-locked" {
  source = "../"

  # Required variables
  name        = "fool"
  location    = "eus"
  environment = "sbox"
  lock_level  = "CanNotDelete"
}

