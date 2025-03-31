resource "databricks_sql_endpoint" "sql_endpoints" {
  for_each = {
    for idx, each in var.sql_endpoints :
    each.name => each
  }

  name             = each.value.name
  cluster_size     = each.value.cluster_size
  min_num_clusters = each.value.min_num_clusters
  max_num_clusters = each.value.max_num_clusters
  auto_stop_mins   = each.value.auto_stop_mins
  warehouse_type   = each.value.warehouse_type
}

resource "databricks_permissions" "endpoint_grants" {
  for_each = {
    for idx, each in var.sql_endpoints :
    each.name => each
  }

  sql_endpoint_id = databricks_sql_endpoint.sql_endpoints[each.key].id

  dynamic "access_control" {
    for_each = each.value.grants

    content {
      group_name             = access_control.value.group_name
      service_principal_name = access_control.value.service_principal_name
      permission_level       = access_control.value.permission_level
    }
  }

  dynamic "access_control" {
    for_each = each.key == "dashboard_warehouse" ? flatten([for obj in var.dashboards : obj.grants]) : []

    content {
      group_name       = access_control.value.group_name
      permission_level = "CAN_USE"
    }
  }
}
