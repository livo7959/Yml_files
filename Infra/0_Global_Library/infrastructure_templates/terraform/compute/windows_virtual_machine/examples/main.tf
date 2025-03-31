# Create resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-vm-test"
  location = "eastus"
}

# Data - Virtual network
data "azurerm_virtual_network" "vnet" {
  name                = "vnet-inf-sandbox-eus-001"
  resource_group_name = "rg-net-inf-sandbox"
}

# Data - Subnet
data "azurerm_subnet" "subnet" {
  name                 = "snet-inf-sandbox-eus-001"
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

# VM Module 
module "virtual_machine" {
  source               = "../../0_Global_Library/infrastructure_templates/terraform/compute/windows_virtual_machine"
  rg                   = "rg-vm-test"
  rg_location          = "eastus"
  vm_name              = "AZTEST002"
  subnet_id            = data.azurerm_subnet.subnet.id
  vm_size              = "Standard_DS2_v2"
  source_image_sku     = "2019-Datacenter"
  local_admin_password = ""
  local_admin_username = ""
  data_disk_config = {
    datadisk1 = {
      name         = "datadisk1"
      disk_size_gb = 32
      lun          = 1
    }
    datadisk2 = {
      name         = "datadisk2"
      disk_size_gb = 32
      lun          = 2

    }
  }
  domain_password = ""

  depends_on = [
    azurerm_resource_group.rg
  ]
}
