resource "databricks_pipeline" "dlt_pipelines" {
  for_each = {
    for each in var.dlt_pipelines :
    each.name => each
  }

  name          = each.value.name
  catalog       = var.env
  target        = each.value.target
  continuous    = each.value.continuous
  development   = each.value.development
  photon        = each.value.photon
  channel       = each.value.channel
  edition       = each.value.edition
  configuration = each.value.configuration

  cluster {
    label               = "default"
    num_workers         = each.value.cluster.num_workers
    node_type_id        = coalesce(each.value.cluster.node_type_id, data.databricks_node_type.smallest.id)        // default to smallest node type
    driver_node_type_id = coalesce(each.value.cluster.driver_node_type_id, data.databricks_node_type.smallest.id) // default to smallest node type
    policy_id           = databricks_cluster_policy.custom_policies[each.value.cluster.policy].id
  }

  dynamic "library" {
    for_each = each.value.notebooks

    content {
      notebook {
        path = library.value
      }
    }
  }
}

resource "databricks_permissions" "dlt_pipeline_usage" {
  for_each = {
    for idx, each in var.dlt_pipelines :
    each.name => each
  }

  pipeline_id = databricks_pipeline.dlt_pipelines[each.key].id

  access_control {
    group_name       = data.databricks_group.databricks_bronze_data_writer.display_name
    permission_level = "CAN_RUN"
  }
}
