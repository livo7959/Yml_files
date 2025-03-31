resource "azuread_group" "law_readers" {
  display_name     = "${module.rg_lh_app_logging.resource_group_name}_log_analytics_reader"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
  description      = "${module.rg_lh_app_logging.resource_group_name} log analytics reader"
}
