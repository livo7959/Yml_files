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
