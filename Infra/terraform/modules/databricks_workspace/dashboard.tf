module "dashboard_contents" {
  source = "../databricks_dashboard_content"
}

resource "databricks_dashboard" "dashboards" {
  for_each = {
    for idx, each in var.dashboards :
    each.name => each
  }

  display_name         = each.value.name
  warehouse_id         = databricks_sql_endpoint.sql_endpoints["dashboard_warehouse"].id
  serialized_dashboard = module.dashboard_contents.dashboard_contents[each.key]
  embed_credentials    = false
  parent_path          = "/Shared/dashboards"
}

resource "databricks_permissions" "dashboard_usage" {
  for_each = {
    for idx, each in var.dashboards :
    each.name => each
  }

  dashboard_id = databricks_dashboard.dashboards[each.key].id

  dynamic "access_control" {
    for_each = each.value.grants

    content {
      group_name       = access_control.value.group_name
      permission_level = access_control.value.permission_level
    }
  }
}
