module "resource_group" {
  source      = "../../../resource-group"
  name        = "test"
  location    = "eus"
  environment = "sbox"
}

data "azurerm_virtual_network" "vnet" {
  name                = "vnet-inf-sandbox-eus-001"
  resource_group_name = "rg-net-inf-sandbox"
}

data "azurerm_subnet" "subnet" {
  name                 = "snet-inf-sandbox-eus-001"
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

module "windows_vm" {
  source = "../"

  resource_group_name  = module.resource_group.resource_group_name
  location             = "eus"
  environment          = "sbox"
  virtual_machine_name = "aztest001"
  admin_password       = ""
  subnet_id            = data.azurerm_subnet.subnet.id
  tags = {
    environment = "sandbox"
    department  = "infrastructure"
  }
}

module "windows_vm_data_disk" {
  source               = "../"
  resource_group_name  = module.resource_group.resource_group_name
  location             = "eus"
  environment          = "sbox"
  virtual_machine_name = "aztest002"
  admin_password       = ""
  subnet_id            = data.azurerm_subnet.subnet.id
  tags = {
    environment = "sandbox"
    department  = "operations"
  }
  data_disk_config = {
    disk1 = {
      disk_size_gb = 10
    },
    disk2 = {
      disk_size_gb = 10
    },
    disk3 = {
      disk_size_gb = 10
    }
  }
}

module "windows_vm_managed_identity" {
  source = "../"

  resource_group_name  = module.resource_group.resource_group_name
  location             = "eus"
  environment          = "sbox"
  virtual_machine_name = "aztest003"
  admin_password       = ""
  subnet_id            = data.azurerm_subnet.subnet.id
  tags = {
    environment = "sandbox"
    department  = "softwaredevelopment"
  }
  identity = {
    type = "SystemAssigned"
  }
}
