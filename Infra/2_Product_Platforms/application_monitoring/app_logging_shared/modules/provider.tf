terraform {
  required_version = ">=1.9.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.4.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "3.0.1"
    }

    azapi = {
      source  = "Azure/azapi"
      version = "1.15"
    }
  }
}

provider "azurerm" {
  features {}
}
