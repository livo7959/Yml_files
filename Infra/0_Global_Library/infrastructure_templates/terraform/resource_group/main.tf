resource "azurerm_resource_group" "rg" {
  name     = lower(var.resource_group_name)
  location = var.location
}
