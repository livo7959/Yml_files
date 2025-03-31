terraform {
  required_version = ">=1.8.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.105.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "2.52.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias                      = "LH-Management-Sub-001"
  tenant_id                  = "54ba6692-0195-4329-9a5d-08a427817083"
  subscription_id            = "fa5c2028-2067-4378-a45a-e3cc445f532b"
  skip_provider_registration = "true"
  features {}
}
