module "resource_group" {
  source      = "../../../../../terraform-modules/resource-group"
  name        = "appinsightstest"
  location    = "eus"
  environment = "sbox"
}

module "log_analytics_workspace" {
  source              = "../../../../../terraform-modules/log-analytics-workspace"
  name                = "test"
  location            = "eus"
  environment         = "sbox"
  resource_group_name = module.resource_group.resource_group_name
  tags = {
    environment = "sandbox"
  }
}

module "action_group" {
  source              = "../../../../../terraform-modules/monitoring/action-group"
  resource_group_name = module.resource_group.resource_group_name
  name                = "test"
  location            = "eus"
  short_name          = "test"
  email_receivers = [
    {
      name          = "test email"
      email_address = "testemail@logixhealth.com"
    },
    {
      name          = "test email_2"
      email_address = "testemail2@logixhealth.com"
    }
  ]
}
module "action_group_2" {
  source              = "../../../../../terraform-modules/monitoring/action-group"
  resource_group_name = module.resource_group.resource_group_name
  name                = "testt"
  location            = "eus"
  short_name          = "testt"
  email_receivers = [
    {
      name          = "test email"
      email_address = "testemail@logixhealth.com"
    },
    {
      name          = "test email_2"
      email_address = "testemail2@logixhealth.com"
    }
  ]
}


module "application_insights" {
  source               = "../"
  name                 = "appi-app-test"
  location             = module.resource-group.resource_group_location
  resource_group_name  = module.resource-group.resource_group_name
  workspace_id         = module.log_analytics_workspace.resource_id
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
    },
    {
      name          = "webtest-test-2"
      description   = "Test 2 for app insights"
      geo_locations = ["us-va-ash-azr"]
      enabled       = true
      frequency     = 600
      retry_enabled = true
      web_test_tags = { environment = "sandbox", managedBy = "terraform" }
      timeout       = 30
      request = {
        url                              = "https://test2.logixhealth.com"
        body                             = null
        follow_redirects_enabled         = true
        http_verb                        = "GET"
        parse_dependent_requests_enabled = true
        headers = [
          { name = "TestHeader", value = "TestValue" },
          { name = "TestHeader2", value = "TestValue2" },
        ]
      }
    },
    {
      name          = "webtest-test-3"
      description   = "Test 3 for app insights"
      geo_locations = ["us-va-ash-azr"]
      enabled       = true
      frequency     = 600
      retry_enabled = true
      web_test_tags = { environment = "sandbox", managedBy = "terraform" }
      timeout       = 30
      request = {
        url                              = "https://test3.logixhealth.com"
        body                             = null
        follow_redirects_enabled         = true
        http_verb                        = "GET"
        parse_dependent_requests_enabled = true
      }
    }
  ]
  smart_detection_rules = [{
    name                               = "Abnormal rise in exception volume"
    enabled                            = false
    send_emails_to_subscription_owners = true
    additional_email_recipients        = ["ttaing@logixhealth.com"]
    },
    {
      name                        = "Slow page load time"
      enabled                     = false
      additional_email_recipients = ["testemail@logixhealth.com"]
    },
    {
      name                        = "Slow server response time"
      additional_email_recipients = ["testemail2@logixhealth.com"]
    }
  ]

  action_group_id = [module.action_group.action_group_id, module.action_group-2.action_group_id] # reference to action group output

}
