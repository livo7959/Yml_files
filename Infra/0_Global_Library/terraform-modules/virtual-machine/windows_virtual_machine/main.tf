# Create network interface card for virtual machine
resource "azurerm_network_interface" "this" {

  name                = "nic-${var.virtual_machine_name}"
  resource_group_name = var.resource_group_name
  location            = module.common_constants.region_short_name_to_long_name[var.location]

  ip_configuration {
    name                          = "nic-config-${var.virtual_machine_name}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
  }
}
# Create virtual machine
resource "azurerm_windows_virtual_machine" "this" {

  name                              = var.virtual_machine_name
  resource_group_name               = var.resource_group_name
  location                          = module.common_constants.region_short_name_to_long_name[var.location]
  size                              = var.virtual_machine_size
  network_interface_ids             = azurerm_network_interface.this.*.id
  admin_username                    = var.admin_username
  admin_password                    = var.admin_password
  provision_vm_agent                = var.provision_vm_agent
  vm_agent_platform_updates_enabled = var.vm_agent_platform_updates_enabled
  zone                              = var.zone
  encryption_at_host_enabled        = var.encryption_at_host_enabled
  hotpatching_enabled               = var.hotpatching_enabled
  secure_boot_enabled               = var.secure_boot_enabled
  vtpm_enabled                      = var.vtpm_enabled
  enable_automatic_updates          = var.enable_automatic_updates
  patch_mode                        = var.patch_mode
  patch_assessment_mode             = var.patch_assessment_mode
  tags                              = local.merged_tags

  os_disk {
    name                 = "osdisk-${var.virtual_machine_name}"
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

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
}

# Creates managed data disk
resource "azurerm_managed_disk" "this" {
  for_each = var.data_disk_config

  name                 = "disk${index(keys(var.data_disk_config), each.key) + 1}-${var.virtual_machine_name}" # disk1-var.virtual_machine_name , disk2-var.virtual_machine_name , etc
  location             = module.common_constants.region_short_name_to_long_name[var.location]
  resource_group_name  = var.resource_group_name
  storage_account_type = each.value.data_disk_storage_account_type
  create_option        = each.value.create_option
  disk_size_gb         = each.value.disk_size_gb
  zone                 = var.zone

}

# Attaches the managed disk to the virtual machine
resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  for_each = var.data_disk_config

  managed_disk_id    = azurerm_managed_disk.this[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.this.id
  lun                = index(keys(var.data_disk_config), each.key) # This will start from 0 so we don't have to define the lun
  caching            = each.value.caching

}

# Extension to join virtual machines to domain via powershell script by Microsoft
# Sandbox subcription does not allow for domain join - can set var.enable_domain_join to false to use without join domain
resource "azurerm_virtual_machine_extension" "domain_join" {
  count                      = var.enable_domain_join ? 1 : 0
  name                       = "domainJoin-${var.virtual_machine_name}"
  virtual_machine_id         = azurerm_windows_virtual_machine.this.id
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

}


