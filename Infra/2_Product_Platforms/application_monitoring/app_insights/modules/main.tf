module "rg" {
  source              = "../../../../0_Global_Library/infrastructure_templates/terraform/resource_group"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.resource_group_tags
}

module "rg_query_pack" {
  source      = "git::https://azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/infrastructure//0_Global_Library/terraform-modules/resource-group?depth=1&ref=resource-group-1.0.1"
  name        = "appiqueries"
  location    = "eus"
  environment = "shared"
}

module "application_insights" {
  source   = "git::https://azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/infrastructure//0_Global_Library/infrastructure_templates/terraform/monitoring/application_insights?depth=1&ref=application-insights-1.0.1"
  for_each = { for instance in var.instances : instance.name => instance }

  name                 = each.value.name
  location             = module.rg.resource_group_location
  resource_group_name  = module.rg.resource_group_name
  workspace_id         = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
  application_type     = each.value.application_type
  daily_data_cap_in_gb = each.value.daily_data_cap_in_gb
  tags                 = each.value.tags
}

