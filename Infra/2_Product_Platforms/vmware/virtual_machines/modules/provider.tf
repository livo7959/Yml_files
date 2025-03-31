terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.8.2"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.105.0"
    }
  }
}
provider "vsphere" {
  user                 = "svc_terravm@corp.logixhealth.local"
  password             = var.vcenter_password
  vsphere_server       = "bedvcenter02.corp.logixhealth.local"
  allow_unverified_ssl = true
}

provider "azurerm" {
  features {}
}
