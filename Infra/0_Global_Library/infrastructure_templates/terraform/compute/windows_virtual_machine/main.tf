# Create network interface card virtual machine
resource "azurerm_network_interface" "vm_nic" {

  name                = "${var.vm_name}-nic"
  resource_group_name = var.rg
  location            = var.rg_location

  ip_configuration {
    name                          = "${var.vm_name}-nic-config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
  }
}

# Create virtual machine
resource "azurerm_windows_virtual_machine" "vm" {

  name                  = var.vm_name
  resource_group_name   = var.rg
  location              = var.rg_location
  size                  = var.vm_size
  network_interface_ids = azurerm_network_interface.vm_nic.*.id
  provision_vm_agent    = true
  admin_username        = var.local_admin_username
  admin_password        = var.local_admin_password
  zone                  = var.availability_zone

  os_disk {
    name                 = "${lower(var.vm_name)}-os-disk"
    caching              = var.os_disk_caching
    storage_account_type = var.os_storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_publisher
    offer     = var.source_image_offer
    sku       = var.source_image_sku
    version   = var.source_image_version
  }

  boot_diagnostics {
    storage_account_uri = var.storage_account_uri

  }

  encryption_at_host_enabled = var.encryption_at_host_enabled
  hotpatching_enabled        = var.hotpatching_enabled
  secure_boot_enabled        = var.secure_boot_enabled
  vtpm_enabled               = var.vtpm_enabled

  depends_on = [
    azurerm_network_interface.vm_nic
  ]
}

# Older azurerm_virtual_machine supports storage_data_disk block but not the new azurerm_windows_virtual_machine 
# Creates managed data disk 
resource "azurerm_managed_disk" "data_disk" {
  for_each = var.data_disk_config

  name                 = each.value.name
  location             = var.rg_location
  resource_group_name  = var.rg
  storage_account_type = each.value.data_disk_storage_account_type
  create_option        = each.value.create_option
  disk_size_gb         = each.value.disk_size_gb
  zone                 = var.availability_zone

  depends_on = [
    azurerm_windows_virtual_machine.vm
  ]
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attachment" {
  for_each = var.data_disk_config

  managed_disk_id    = azurerm_managed_disk.data_disk[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  lun                = each.value.lun
  caching            = each.value.caching

  depends_on = [
    azurerm_managed_disk.data_disk
  ]
}

# Extension to join virtual machines to domain via powershell script by Microsoft
# Sandbox subcription does not allow for domain join - Comment out when testing in sandbox or deployment will fail/timeout
resource "azurerm_virtual_machine_extension" "domain_join" {
  name                       = "${var.vm_name}-domainJoin"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "Name": "${var.domain_name}",
      "OUPath": "${var.ou_path}",
      "User": "${var.domain_user_upn}@${var.domain_name}",
      "Restart": "true",
      "Options": "3"
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "Password": "${var.domain_password}"
    }
PROTECTED_SETTINGS

  lifecycle {
    ignore_changes = [settings, protected_settings]
  }

  depends_on = [
    azurerm_virtual_machine_data_disk_attachment.data_disk_attachment
  ]
}


