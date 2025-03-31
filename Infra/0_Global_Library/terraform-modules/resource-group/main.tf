# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group
resource "azurerm_resource_group" "this" {
  name     = "rg-${local.base_name}"
  location = module.common_constants.region_short_name_to_long_name[var.location]
  tags     = local.merged_tags
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock
resource "azurerm_management_lock" "this" {
  count = var.lock_level == "" ? 0 : 1

  name       = "${azurerm_resource_group.this.name}-lock"
  scope      = azurerm_resource_group.this.id
  lock_level = var.lock_level
  notes      = "Resource group is locked with \"${var.lock_level}\" level."
}
