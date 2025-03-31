module "rg_lh_app_logging" {
  source      = "git::https://azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/infrastructure//0_Global_Library/terraform-modules/resource-group?depth=1&ref=resource-group-1.0.1"
  name        = "lhapplogging"
  location    = "eus"
  environment = "shared"
}

module "data_collection_endpoint" {
  source                        = "git::https://azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/infrastructure//0_Global_Library/terraform-modules/data-collection-endpoint?depth=1&ref=data-collection-endpoint-1.0.1"
  name                          = "lhapps"
  resource_group                = module.rg_lh_app_logging.resource_group_name
  location                      = "eus"
  environment                   = "shared"
  public_network_access_enabled = true
  tags = {
    environment = "shared"
  }
}

module "log_analytics_workspace" {
  source              = "git::https://azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/infrastructure//0_Global_Library/terraform-modules/log-analytics-workspace?depth=1&ref=log-analytics-workspace-1.0.0"
  name                = "lhapps"
  location            = "eus"
  environment         = "shared"
  resource_group_name = module.rg_lh_app_logging.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 90
  tags = {
    environment = "shared"
  }
}
