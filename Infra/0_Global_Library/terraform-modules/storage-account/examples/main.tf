provider "azurerm" {
  features {}
}

module "storage_account" {
  source = "../"

  environment    = "sbox"
  location       = "eus"
  resource_group = "rg-foo"
  name           = "foo"
}
