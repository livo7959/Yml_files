terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">3.8.5"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}
