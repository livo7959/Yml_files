resource "azurerm_container_app_environment" "this" {
  name                               = "cae-${local.base_name}"
  location                           = module.common_constants.region_short_name_to_long_name[var.location]
  resource_group_name                = var.resource_group_name
  infrastructure_resource_group_name = var.infrastructure_resouce_group_name
  infrastructure_subnet_id           = var.infrastructure_subnet_id
  internal_load_balancer_enabled     = var.internal_load_balancer_enabled
  zone_redundancy_enabled            = var.zone_redundancy_enabled
  tags                               = local.merged_tags
  dynamic "workload_profile" {
    for_each = var.workload_profile != null ? [var.workload_profile] : []
    content {
      name                  = workload_profile.value.name
      workload_profile_type = workload_profile.value.workload_profile_type
      maximum_count         = workload_profile.value.maximum_count
      minimum_count         = workload_profile.value.minimum_count
    }
  }
}
