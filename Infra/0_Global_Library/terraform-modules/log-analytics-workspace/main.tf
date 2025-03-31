resource "azurerm_log_analytics_workspace" "this" {
  name                                    = "log-${local.base_name}"
  location                                = module.common_constants.region_short_name_to_long_name[var.location]
  resource_group_name                     = var.resource_group_name
  sku                                     = var.sku
  retention_in_days                       = var.retention_in_days
  allow_resource_only_permissions         = var.allow_resource_only_permissions
  local_authentication_disabled           = var.local_authentication_disabled
  daily_quota_gb                          = var.daily_quota_gb
  cmk_for_query_forced                    = var.cmk_for_query_forced
  internet_ingestion_enabled              = var.internet_ingestion_enabled
  internet_query_enabled                  = var.internet_query_enabled
  reservation_capacity_in_gb_per_day      = var.reservation_capacity_in_gb_per_day
  data_collection_rule_id                 = var.data_collection_rule_id
  immediate_data_purge_on_30_days_enabled = var.immediate_data_purge_on_30_days_enabled
  tags                                    = local.merged_tags
  dynamic "identity" {
    for_each = var.identity
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids

    }
  }
}
