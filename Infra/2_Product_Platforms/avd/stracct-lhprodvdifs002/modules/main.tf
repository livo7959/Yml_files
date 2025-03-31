#This code creates and maintains the storage account and file shares to store FSlogix profiles


data "azurerm_resource_group" "srtrgname" {
  name = var.resource_group_name
}

data "azurerm_subnet" "strsub" {
  name                 = var.avdsub
  virtual_network_name = var.vnetname
  resource_group_name  = var.rg-vnet

}

data "azurerm_subnet" "strsub1" {
  name                 = var.avdsub1
  virtual_network_name = var.vnetname
  resource_group_name  = var.rg-vnet

}


data "azurerm_subnet" "strsub2" {
  name                 = var.avdsub2
  virtual_network_name = var.vnetname
  resource_group_name  = var.rg-vnet

}

resource "azurerm_storage_account" "azstorage1" {
  name                     = var.stracctname
  resource_group_name      = data.azurerm_resource_group.srtrgname.name
  location                 = data.azurerm_resource_group.srtrgname.location
  account_tier             = var.accttier
  account_replication_type = var.acctreptype
  account_kind             = "FileStorage"


  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [data.azurerm_subnet.strsub.id, data.azurerm_subnet.strsub1.id, data.azurerm_subnet.strsub2.id]
  }

}


resource "azurerm_storage_share" "infrafsshare" {
  name               = var.sharename
  storage_account_id = azurerm_storage_account.azstorage1.id
  quota              = var.sharesize #size in GB

}


