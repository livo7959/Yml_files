terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.53.1"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.3.0"
    }
  }

  required_version = ">= 1.9"
}
