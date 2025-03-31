resource "azurerm_application_insights" "application_insights" {
  name                 = var.name
  location             = var.location
  resource_group_name  = var.resource_group_name
  workspace_id         = var.workspace_id
  application_type     = var.application_type
  daily_data_cap_in_gb = var.daily_data_cap_in_gb
  tags                 = var.tags
}

resource "azurerm_application_insights_standard_web_test" "this" {
  for_each                = { for i, web_test in var.web_tests : i => web_test }
  name                    = each.value.name
  resource_group_name     = azurerm_application_insights.application_insights.resource_group_name
  location                = azurerm_application_insights.application_insights.location
  application_insights_id = azurerm_application_insights.application_insights.id
  geo_locations           = each.value.geo_locations
  description             = each.value.description
  enabled                 = each.value.enabled
  frequency               = each.value.frequency
  retry_enabled           = each.value.retry_enabled
  tags                    = each.value.web_test_tags
  timeout                 = each.value.timeout

  request {
    url                              = each.value.request.url
    body                             = each.value.request.body
    follow_redirects_enabled         = each.value.request.follow_redirects_enabled
    http_verb                        = each.value.request.http_verb
    parse_dependent_requests_enabled = each.value.request.parse_dependent_requests_enabled
    dynamic "header" {
      for_each = each.value.request.headers
      content {
        name  = header.value.name
        value = header.value.value
      }
    }
  }

  dynamic "validation_rules" {
    for_each = each.value.validation_rules != null ? [1] : [] # This checks if validation_rules has been defined or not since it's optional. If it is not null, it means that the block is defined and can be created. If null, will skip. Without this , get error "cannot use a null value in for_each"
    content {
      expected_status_code        = each.value.validation_rules.expected_status_code
      ssl_cert_remaining_lifetime = each.value.validation_rules.ssl_cert_remaining_lifetime
      ssl_check_enabled           = each.value.validation_rules.ssl_check_enabled

      dynamic "content" {
        for_each = each.value.validation_rules.content_match != null ? [1] : []
        content {
          content_match      = each.value.validation_rules.content_match
          ignore_case        = each.value.validation_rules.ignore_case
          pass_if_text_found = each.value.validation_rules.pass_if_text_found
        }
      }
    }
  }
}

resource "azurerm_application_insights_smart_detection_rule" "this" {
  for_each = { for i, rule in var.smart_detection_rules : i => rule }

  name                               = each.value.name
  application_insights_id            = azurerm_application_insights.application_insights.id
  enabled                            = each.value.enabled
  send_emails_to_subscription_owners = lookup(each.value, "send_emails_to_subscription_owners", false)
  additional_email_recipients        = lookup(each.value, "additional_email_recipients", toset([]))
}

# This gets created in portal automatically and in a disabled state.
# To do so, need to edit the standard Webtest in portal > and just save the config as is and it will generate
# Adding this block will override the default creation in portal
resource "azurerm_monitor_metric_alert" "this" {
  for_each            = azurerm_application_insights_standard_web_test.this
  name                = "${each.value.name}-availability-alert"
  resource_group_name = azurerm_application_insights.application_insights.resource_group_name
  scopes              = [azurerm_application_insights.application_insights.id, each.value.id]
  description         = "${each.value.name}-location-availibility alert"
  severity            = var.severity
  enabled             = var.enabled
  auto_mitigate       = var.auto_mitigate
  frequency           = var.frequency
  window_size         = var.window_size
  application_insights_web_test_location_availability_criteria {
    web_test_id           = each.value.id
    component_id          = azurerm_application_insights.application_insights.id
    failed_location_count = var.failed_location_count
  }
  dynamic "action" {
    for_each = var.action_group_id
    content {
      action_group_id = action.value
    }
  }
}
