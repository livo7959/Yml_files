# The below code will deploy Resource group, workspace ,hostpool and application group.

# Create a Resource group
resource "azurerm_resource_group" "rgname" {
  name     = var.rg_name
  location = var.resource_group_location
}

# Create AVD workspace
resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = var.workspace
  resource_group_name = azurerm_resource_group.rgname.name
  location            = azurerm_resource_group.rgname.location
  friendly_name       = "${var.prefix} Workspace"
  description         = "${var.prefix} Workspace"
  depends_on          = [azurerm_resource_group.rgname]
}

# Create AVD host pool
resource "azurerm_virtual_desktop_host_pool" "hostpool" {
  resource_group_name      = azurerm_resource_group.rgname.name
  location                 = azurerm_resource_group.rgname.location
  name                     = var.hostpool
  friendly_name            = var.hostpool
  validate_environment     = false
  custom_rdp_properties    = var.custom_rdp_properties
  description              = "${var.prefix} Terraform HostPool"
  type                     = "Pooled"
  maximum_sessions_allowed = var.maxsessions
  load_balancer_type       = var.load_balancer_type
  scheduled_agent_updates {
    enabled = true
    schedule {
      day_of_week = "Saturday"
      hour_of_day = 2
    }
  }

  depends_on = [azurerm_resource_group.rgname, azurerm_virtual_desktop_workspace.workspace]
}

# Create AVD DAG
resource "azurerm_virtual_desktop_application_group" "dag" {
  resource_group_name          = azurerm_resource_group.rgname.name
  host_pool_id                 = azurerm_virtual_desktop_host_pool.hostpool.id
  location                     = azurerm_resource_group.rgname.location
  type                         = "Desktop"
  name                         = "${var.prefix}-dag"
  friendly_name                = "Desktop AppGroup"
  description                  = "AVD application group"
  default_desktop_display_name = var.published_desktop_name
  depends_on                   = [azurerm_virtual_desktop_host_pool.hostpool, azurerm_virtual_desktop_workspace.workspace, azurerm_resource_group.rgname]
}

# Associate Workspace and DAG
resource "azurerm_virtual_desktop_workspace_application_group_association" "WS-DAG" {
  application_group_id = azurerm_virtual_desktop_application_group.dag.id
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
  depends_on           = [azurerm_resource_group.rgname, azurerm_virtual_desktop_host_pool.hostpool, azurerm_virtual_desktop_application_group.dag]
}

