terraform {
  required_version = ">=1.9.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.10.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "3.0.2"
    }
  }
}

provider "azurerm" {
  subscription_id = "59161e1f-62f6-456e-93d6-162d6f3c6d91"
  features {}
}
