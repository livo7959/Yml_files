resource "azurerm_example" "this" {
  name                = "resource-abbreviation-${local.base_name}"
  location            = module.common_constants.region_short_name_to_long_name[var.location]
  resource_group_name = var.resource_group_name
  tags                = local.merged_tags
}
