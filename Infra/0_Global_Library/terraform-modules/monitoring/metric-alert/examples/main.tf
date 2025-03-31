module "resource-group" {
  source      = "../../../resource-group"
  name        = "testing"
  location    = "eus"
  environment = "sbox"
}

module "log-analytics-workspace" {
  source              = "../../../log-analytics-workspace"
  name                = "test"
  location            = "eus"
  environment         = "sbox"
  resource_group_name = module.resource-group.resource_group_name
  tags = {
    environment = "sandbox"
  }
}

module "application_insights" {
  source               = "../../../../infrastructure_templates/terraform/monitoring/application_insights"
  name                 = "appi-app-test"
  location             = module.resource-group.resource_group_location
  resource_group_name  = module.resource-group.resource_group_name
  workspace_id         = module.log-analytics-workspace.resource_id
  application_type     = "web"
  daily_data_cap_in_gb = 10
  tags = {
    environment = "sandbox"
    managedBy   = "terraform"
  }
  web_tests = [
    {
      name          = "webtest-test-1"
      description   = "test 1 for app insights"
      geo_locations = ["us-va-ash-azr"]
      enabled       = true
      frequency     = 600
      retry_enabled = true
      web_test_tags = { environment = "sandbox", managedBy = "terraform" }
      timeout       = 30
      request = {
        url                              = "https://test.logixhealth.com"
        body                             = null
        follow_redirects_enabled         = true
        http_verb                        = "GET"
        parse_dependent_requests_enabled = true
        headers = [
          { name = "TestHeader", value = "TestValue" }
        ]
      }
      validation_rules = {
        expected_status_code        = 200
        ssl_cert_remaining_lifetime = 30
        ssl_check_enabled           = true
        content_match               = "test"
        ignore_case                 = true
        pass_if_text_found          = true
      }
    }
  ]
}

module "action_group" {
  source              = "../../action-group"
  resource_group_name = module.resource-group.resource_group_name
  name                = "test"
  short_name          = "ta-ag"
  location            = "eus"
  email_receivers = [
    {
      name          = "test email"
      email_address = "test@logixhealth.com"
    },
    {
      name          = "test email2"
      email_address = "test2@logixhealth.com"
    }
  ]
}
module "alerts-criteria" {
  source              = "../"
  resource_group_name = module.resource-group.resource_group_name
  scopes              = [module.application_insights.id]
  name                = "testalert-criteria"
  description         = "alert testing criteria with no dimension needed"
  severity            = "4"
  enabled             = true
  criteria = [
    {
      metric_namespace = "Microsoft.Insights/Components"
      metric_name      = "dependencies/count"
      aggregation      = "Count"
      operator         = "GreaterThan"
      threshold        = 50
    }
  ]
  frequency   = "PT1M"
  window_size = "PT5M"
  tags = {
    environment = "sandbox"
  }
  action_group_id = module.action_group.action_group_id
}

module "alerts-dynamic-criteria" {
  source              = "../"
  resource_group_name = module.resource-group.resource_group_name
  scopes              = [module.application_insights.id]
  name                = "testalert-dynamic-criteria"
  description         = "alert testing dynamic criteria with no dimension needed"
  severity            = "4"
  enabled             = true
  dynamic_criteria = [
    {
      metric_namespace         = "Microsoft.Insights/Components"
      metric_name              = "dependencies/count"
      aggregation              = "Count"
      operator                 = "GreaterThan"
      threshold                = 90
      alert_sensitivity        = "Low"
      evaluation_total_count   = 4
      evaluation_failure_count = 4
      ignore_data_before       = "2024-07-27T15:04:05Z"
      skip_metric_validation   = false
    }
  ]
  frequency   = "PT1M"
  window_size = "PT5M"
  tags = {
    environment = "sandbox"
  }
  action_group_id = module.action_group.action_group_id
}

module "alerts-application_insights_web_test_location_availability_criteria" {
  source              = "../"
  resource_group_name = module.resource-group.resource_group_name
  scopes              = [module.application_insights.id, module.application_insights.web_test_id[0]]
  name                = "testalert-aiwtlac"
  description         = "Alert testing application insights web test location availability"
  severity            = "4"
  enabled             = true
  application_insights_web_test_location_availability_criteria = [
    {
      web_test_id           = module.application_insights.web_test_id[0]
      component_id          = module.application_insights.id
      failed_location_count = 2

    }
  ]
  frequency   = "PT1M"
  window_size = "PT5M"
  tags = {
    environment = "sandbox"
  }
  action_group_id = module.action_group.action_group_id
}
