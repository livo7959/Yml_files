resource "databricks_job" "databricks_jobs" {
  for_each = {
    for idx, each in var.job_configurations :
    each.name => each
  }

  name        = each.value.name
  description = each.value.description

  dynamic "task" {
    for_each = each.value.tasks
    content {
      task_key            = task.key
      existing_cluster_id = task.value.existing_cluster_name != null ? databricks_cluster.cluster[task.value.existing_cluster_name].id : null

      dynamic "pipeline_task" {
        for_each = task.value.pipeline_task != null ? [task.value.pipeline_task] : []
        content {
          pipeline_id = databricks_pipeline.dlt_pipelines[pipeline_task.value.pipeline_name].id
        }
      }

      dynamic "notebook_task" {
        for_each = task.value.notebook_task != null ? [task.value.notebook_task] : []
        content {
          notebook_path = notebook_task.value.notebook_name
        }
      }

      dynamic "depends_on" {
        for_each = task.value.dependencies
        content {
          task_key = depends_on.value
        }
      }
    }
  }

  dynamic "schedule" {
    for_each = each.value.schedule != null ? [each.value.schedule] : []
    content {
      quartz_cron_expression = schedule.value.quartz_cron_expression
      timezone_id            = schedule.value.timezone_id
    }
  }
}

resource "databricks_permissions" "job_usage" {
  for_each = {
    for idx, each in var.job_configurations :
    each.name => each
  }

  job_id = databricks_job.databricks_jobs[each.key].id

  access_control {
    group_name       = data.databricks_group.databricks_bronze_data_writer.display_name
    permission_level = "CAN_MANAGE_RUN"
  }
}
