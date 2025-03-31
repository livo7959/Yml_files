data "databricks_node_type" "smallest" {
  local_disk = true
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

resource "databricks_cluster" "cluster" {
  for_each = {
    for idx, each in var.cluster_configurations :
    each.name => each
  }

  cluster_name            = each.value.name
  spark_version           = coalesce(each.value.spark_version, data.databricks_spark_version.latest_lts.id)
  node_type_id            = coalesce(each.value.node_type_id, data.databricks_node_type.smallest.id)
  autotermination_minutes = each.value.autotermination_minutes
  data_security_mode      = "USER_ISOLATION"

  autoscale {
    min_workers = 1
    max_workers = each.value.max_workers
  }
}

resource "databricks_permissions" "cluster_usage" {
  for_each = {
    for idx, each in var.cluster_configurations :
    each.name => each
  }

  cluster_id = databricks_cluster.cluster[each.key].id

  access_control {
    group_name       = data.databricks_group.databricks_bronze_data_writer.display_name
    permission_level = "CAN_RESTART"
  }
}

resource "databricks_cluster_policy" "custom_policies" {
  for_each = {
    for each in var.cluster_policies :
    each.name => each
  }

  name        = each.value.name
  description = each.value.description
  definition  = jsonencode(each.value.definition)
}
