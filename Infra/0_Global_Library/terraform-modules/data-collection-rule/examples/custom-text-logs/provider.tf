terraform {
  required_version = ">=1.9.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.2.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "1.15"
    }
  }
}


