terraform {
  required_version = ">=1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.13.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "example" {
  source = "../"

  name                = "example"
  environment         = "sbx"
  location            = "eus"
  resource_group_name = "rg-example-eus-test"
  tags = {
    environment = "sbx"
  }
}
