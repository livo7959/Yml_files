data "azurerm_resource_group" "hprgname" {
  name = var.hp-rgname

}

data "azurerm_virtual_desktop_host_pool" "existinghostpool" {
  name                = var.hostpool
  resource_group_name = data.azurerm_resource_group.hprgname.name
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "registrationinfo" {
  hostpool_id     = data.azurerm_virtual_desktop_host_pool.existinghostpool.id
  expiration_date = var.rfc3339
}

locals {
  registration_token = azurerm_virtual_desktop_host_pool_registration_info.registrationinfo.token
}

# Summoning password from Key Vault in AVD sub
data "azurerm_key_vault" "lhkvavdprod" {
  name                = "lh-kv-avd-prod"
  resource_group_name = "rg-kv-avd-001"
}

data "azurerm_key_vault_secret" "avdlocaladmin" {
  name         = "avd-localadmin"
  key_vault_id = data.azurerm_key_vault.lhkvavdprod.id

}

data "azurerm_key_vault_secret" "svcjoindomain" {
  name         = "svc-joindomain"
  key_vault_id = data.azurerm_key_vault.lhkvavdprod.id

}

# Referencing existing Subnet and VLAN for host pool deployment

data "azurerm_subnet" "avdsub" {
  name                 = var.avdsub
  virtual_network_name = var.vnetname
  resource_group_name  = var.rg-vnet

}

# NIC card creation based on the number of session hosts

resource "azurerm_network_interface" "avd_vm_nic" {
  count               = var.rdsh_count
  name                = "${var.prefix}-${count.index + 1}-nic"
  resource_group_name = data.azurerm_resource_group.hprgname.name
  location            = data.azurerm_resource_group.hprgname.location

  ip_configuration {
    name                          = "nic${count.index + 1}_config"
    subnet_id                     = data.azurerm_subnet.avdsub.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [
    data.azurerm_resource_group.hprgname
  ]
}

# Session VM's creation

resource "azurerm_windows_virtual_machine" "avd_vm" {
  count                 = var.rdsh_count
  name                  = "${var.prefix}-${count.index + 1}"
  resource_group_name   = data.azurerm_resource_group.hprgname.name
  location              = data.azurerm_resource_group.hprgname.location
  size                  = var.vm_size
  network_interface_ids = ["${azurerm_network_interface.avd_vm_nic.*.id[count.index]}"]
  provision_vm_agent    = true
  admin_username        = var.local_admin_username
  admin_password        = data.azurerm_key_vault_secret.avdlocaladmin.value

  os_disk {
    name                 = "${lower(var.prefix)}-${count.index + 1}"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_id = var.source_image_id

  depends_on = [
    data.azurerm_resource_group.hprgname,
    azurerm_network_interface.avd_vm_nic
  ]
}


resource "azurerm_virtual_machine_extension" "vmext_dsc" {
  count                      = var.rdsh_count
  name                       = "${var.prefix}${count.index + 1}-avd_dsc"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = <<-SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${data.azurerm_virtual_desktop_host_pool.existinghostpool.name}"
      }
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "properties": {
      "registrationInfoToken": "${local.registration_token}"
    }
  }
PROTECTED_SETTINGS

  depends_on = [
    azurerm_windows_virtual_machine.avd_vm
  ]
}

# Domain join code for session hosts
resource "azurerm_virtual_machine_extension" "domain_join" {
  count                      = var.rdsh_count
  name                       = "${var.prefix}-${count.index + 1}-domainJoin"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
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
      "Password": "${data.azurerm_key_vault_secret.svcjoindomain.value}"

          }
PROTECTED_SETTINGS

  lifecycle {
    ignore_changes = [settings, protected_settings]
  }
  depends_on = [azurerm_virtual_machine_extension.vmext_dsc]

}

resource "azurerm_virtual_machine_extension" "ama" {
  count                      = var.rdsh_count
  name                       = "${var.prefix}-${count.index + 1}-AzureMonitorWindowsAgent"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = "true"
  depends_on                 = [azurerm_virtual_machine_extension.vmext_dsc]

}

# Associate session hosts with Data collection rule

data "azurerm_monitor_data_collection_rule" "dcrrule" {
  name                = var.datacollectionrule
  resource_group_name = var.rgalerts

}

resource "azurerm_monitor_data_collection_rule_association" "dcrassociation" {
  count                   = var.rdsh_count
  name                    = "${var.prefix}-${count.index + 1}-DCRAgent"
  target_resource_id      = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
  data_collection_rule_id = data.azurerm_monitor_data_collection_rule.dcrrule.id
}
