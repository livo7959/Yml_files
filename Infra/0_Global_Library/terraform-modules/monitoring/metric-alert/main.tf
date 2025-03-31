resource "azurerm_monitor_metric_alert" "this" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  scopes                   = var.scopes
  description              = var.description
  severity                 = var.severity
  enabled                  = var.enabled
  auto_mitigate            = var.auto_mitigate
  frequency                = var.frequency
  window_size              = var.window_size
  tags                     = local.merged_tags
  target_resource_type     = var.target_resource_type
  target_resource_location = var.target_resource_location
  dynamic "criteria" {
    for_each = var.criteria
    content {
      metric_namespace = criteria.value.metric_namespace
      metric_name      = criteria.value.metric_name
      aggregation      = criteria.value.aggregation
      operator         = criteria.value.operator
      threshold        = criteria.value.threshold

      dynamic "dimension" {
        for_each = criteria.value.dimension != null ? [criteria.value.dimension] : []
        content {
          name     = dimension.value.name
          operator = dimension.value.operator
          values   = dimension.value.values
        }
      }
    }
  }
  dynamic "dynamic_criteria" {
    for_each = var.dynamic_criteria
    content {
      metric_namespace         = dynamic_criteria.value.metric_namespace
      metric_name              = dynamic_criteria.value.metric_name
      aggregation              = dynamic_criteria.value.aggregation
      operator                 = dynamic_criteria.value.operator
      alert_sensitivity        = dynamic_criteria.value.alert_sensitivity
      evaluation_total_count   = dynamic_criteria.value.evaluation_total_count
      evaluation_failure_count = dynamic_criteria.value.evaluation_failure_count
      ignore_data_before       = dynamic_criteria.value.ignore_data_before
      skip_metric_validation   = dynamic_criteria.value.skip_metric_validation
      dynamic "dimension" {
        for_each = dynamic_criteria.value.dimension != null ? [1] : []
        content {
          name     = dimension.value.dimension_name
          operator = dimension.value.dimension_operator
          values   = dimension.value.dimension_values
        }
      }
    }
  }
  dynamic "application_insights_web_test_location_availability_criteria" {
    for_each = var.application_insights_web_test_location_availability_criteria
    content {

      web_test_id           = application_insights_web_test_location_availability_criteria.value.web_test_id
      component_id          = application_insights_web_test_location_availability_criteria.value.component_id
      failed_location_count = application_insights_web_test_location_availability_criteria.value.failed_location_count
    }
  }
  action {
    action_group_id = var.action_group_id
  }
}
