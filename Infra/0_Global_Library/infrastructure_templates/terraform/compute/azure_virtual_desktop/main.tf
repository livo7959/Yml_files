# Create resource group
resource "azurerm_resource_group" "rg" {
  name     = var.rg
  location = var.resource_group_location
}

# Create AVD workspace
resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = var.workspace
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  friendly_name       = "${var.workspace} Workspace"
  description         = "${var.workspace} Workspace"
}

# Create AVD host pool
resource "azurerm_virtual_desktop_host_pool" "hostpool" {
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  name                     = var.hostpool
  friendly_name            = var.hostpool
  validate_environment     = true
  description              = "${var.hostpool} HostPool"
  type                     = var.hostpool_type
  maximum_sessions_allowed = var.maximum_sessions_allowed
  load_balancer_type       = var.loadbalancer_type
  custom_rdp_properties    = var.custom_rdp_properties
}

# Create AVD desktop application group
resource "azurerm_virtual_desktop_application_group" "dag" {
  resource_group_name = azurerm_resource_group.rg.name
  host_pool_id        = azurerm_virtual_desktop_host_pool.hostpool.id
  location            = azurerm_resource_group.rg.location
  type                = "Desktop"
  name                = "${var.dag}-DAG"
  friendly_name       = "Desktop application group"
  description         = "AVD desktop application group"
  depends_on          = [azurerm_virtual_desktop_host_pool.hostpool, azurerm_virtual_desktop_workspace.workspace]
}

# DAG RBAC for Virtualization User - Go into an existing DAG's IAM and you will see DAG assigned here
# Data block to an existing built-in role
data "azurerm_role_definition" "role" {
  name = "Desktop Virtualization User"
}

# Must activate "PIM_Systems_Support_Admins" PIM group role or PIM User Administrator role to create entra id group
# Creates entra group for DAG group
resource "azuread_group" "entra_group" {
  display_name     = var.entra_group
  security_enabled = true
}

# Assigns desktop virtualization user role to Entra group and DAG
resource "azurerm_role_assignment" "role_assignment" {
  scope              = azurerm_virtual_desktop_application_group.dag.id
  role_definition_id = data.azurerm_role_definition.role.id
  principal_id       = azuread_group.entra_group.id

  depends_on = [
    azuread_group.entra_group,
    azurerm_virtual_desktop_application_group.dag

  ]
}

# Associate workspace and desktop application group
resource "azurerm_virtual_desktop_workspace_application_group_association" "ws-dag" {
  application_group_id = azurerm_virtual_desktop_application_group.dag.id
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
}

locals {
  registration_token = azurerm_virtual_desktop_host_pool_registration_info.registrationinfo.token
}

# Create host pool registration token
resource "azurerm_virtual_desktop_host_pool_registration_info" "registrationinfo" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.hostpool.id
  expiration_date = var.rfc3339
}

# Create network interface cards for each virtual machine
resource "azurerm_network_interface" "vm_nic" {
  count               = var.sh_count
  name                = "${var.prefix}-${count.index + 1}-nic"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "nic${count.index + 1}_config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [
    azurerm_resource_group.rg
  ]
}

# Create virtual machines
resource "azurerm_windows_virtual_machine" "vm" {
  count                 = var.sh_count
  name                  = "${var.prefix}-${count.index + 1}"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = var.vm_size
  network_interface_ids = ["${azurerm_network_interface.vm_nic.*.id[count.index]}"]
  provision_vm_agent    = true
  admin_username        = var.local_admin_username
  admin_password        = var.local_admin_password

  os_disk {
    name                 = "${lower(var.prefix)}-${count.index + 1}"
    caching              = "ReadWrite"
    storage_account_type = var.os_storage_account_type
  }

  source_image_id = var.source_image_id

  /* # One of the argument references source_image_id or source_image_reference must be set
     # Was having issues with source_image_reference with custom images from azure shared compute gallery. Specifically
       the Data Sources with azurerm_shared_image_version and azurerm_shared_image_versions. Both could not read the image definition\image versions.
     # Works with standard marketplace image fine
     # Commenting out to use source_image_id of the image directly which will use the latest version set on the definition by default

  source_image_reference {
    publisher = "microsoftwindowsdesktop"
    offer     = "Windows-11"
    sku       = "VM-Billing-img"
    version   = "latest"
  }
  */
  identity {
    type = var.identity_type
  }
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_network_interface.vm_nic
  ]
}

# Extension to join virtual machines to domain via powershell script by Microsoft
# Sandbox subscription does not allow for domain join - Comment out when testing in sandbox or deployment will fail/timeout
resource "azurerm_virtual_machine_extension" "domain_join" {
  count                      = var.sh_count
  name                       = "${var.prefix}-${count.index + 1}-domainJoin"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.*.id[count.index]
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

# Extension to add virtual machines as SessionHosts to host pool
# Depends on domain join ext - vm can reboot during domain addition and will error out adding session host to host pool
# Depends on hostpool - host pool needs to be created first
resource "azurerm_virtual_machine_extension" "vmext_dsc" {
  count                      = var.sh_count
  name                       = "${var.prefix}${count.index + 1}-avd_dsc"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.*.id[count.index]
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = <<-SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${azurerm_virtual_desktop_host_pool.hostpool.name}"
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
    azurerm_virtual_machine_extension.domain_join
  ]
}

# Azure monitor agent install
resource "azurerm_virtual_machine_extension" "ama" {
  count                     = var.sh_count
  name                      = "${var.prefix}${count.index + 1}-AzureMonitorWindowsAgent"
  virtual_machine_id        = azurerm_windows_virtual_machine.vm.*.id[count.index]
  publisher                 = "Microsoft.Azure.Monitor"
  type                      = "AzureMonitorWindowsAgent"
  type_handler_version      = "1.0"
  automatic_upgrade_enabled = "true"

  depends_on = [
    azurerm_virtual_machine_extension.vmext_dsc
  ]
}

# Data block for existing AVD insights data collection rule
data "azurerm_monitor_data_collection_rule" "insights" {
  name                = var.dcr_insights_name
  resource_group_name = var.dcr_insights_rg
}

# Associate VM w/ azure monitor agent to AVD insights data collection rule
resource "azurerm_monitor_data_collection_rule_association" "insights" {
  count                   = var.sh_count
  name                    = "${var.prefix}-${count.index + 1}"
  target_resource_id      = azurerm_windows_virtual_machine.vm.*.id[count.index]
  data_collection_rule_id = data.azurerm_monitor_data_collection_rule.insights.id
  description             = "Associates session hosts to insights DCR"
}
