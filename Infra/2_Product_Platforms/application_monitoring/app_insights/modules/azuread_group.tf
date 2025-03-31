resource "azuread_group" "rg_monitoring_read_group" {
  display_name     = "${var.resource_group_name}_monitoring_reader"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
  description      = "${var.resource_group_name} monitoring readers"
}

resource "azuread_group" "rg_log_analytics_contributor" {
  display_name     = "${module.rg_query_pack.resource_group_name}_log_analytics_contributor"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
  description      = "${module.rg_query_pack.resource_group_name} log analytics contributor"
}

