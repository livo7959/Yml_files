data "azurerm_log_analytics_workspace" "law" {
  name                = "existing_law_name"
  resource_group_name = "rg-name"
}

data "azurerm_monitor_data_collection_endpoint" "dep" {
  name                = "dep-data-collection-sbox"
  resource_group_name = "rg-data-collection-sbox"
}

module "dcr" {
  source                      = "../"
  resource_group              = data.azurerm_monitor_data_collection_endpoint.dep.resource_group_name
  name                        = "dcrtest"
  location                    = "eus"
  environment                 = "sbox"
  data_collection_endpoint_id = data.azurerm_monitor_data_collection_endpoint.dep.id
  collection_rules = [
    {
      data_sources = {
        windows_event_log = {
          name           = "windowslogs"
          streams        = ["Microsoft-Event"]
          x_path_queries = ["Security!*[System[(EventID=4624)]]"]
        },
        syslog = {
          facility_names = ["alert", "audit", "auth"]
          log_levels     = ["Info"]
          streams        = ["Microsoft-Syslog"]
        }
      }
      data_flow = {
        streams      = ["Microsoft-Event", "Microsoft-Syslog"]
        destinations = ["ws-test"]
      }
      destinations = {
        log_analytics = {
          workspace_resource_id = data.azurerm_log_analytics_workspace.law.id
          name                  = "ws-test"
        }
      }
    }
  ]
  associations = [
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "resource-id-of-vm-or-arc-machine"
    }
  ]
}

module "dcrtest2" {
  source                      = "../"
  resource_group              = data.azurerm_monitor_data_collection_endpoint.dep.resource_group_name
  name                        = "dcrtesttwo"
  location                    = "eus"
  environment                 = "sbox"
  data_collection_endpoint_id = data.azurerm_monitor_data_collection_endpoint.dep.id
  collection_rules = [
    {
      data_sources = {
        windows_event_log = {
          streams        = ["Microsoft-Event"]
          x_path_queries = ["Security!*[System[(EventID=4624)]]"]
        },
        syslog = {
          facility_names = ["alert", "audit", "auth"]
          log_levels     = ["Info"]
          streams        = ["Microsoft-Syslog"]
        },
        iis_log = {
          log_directories = ["C:\\Logs\\W3SVC1"]
          streams         = ["Microsoft-W3CIISLog"]
        }
      }
      data_flow = {
        streams      = ["Microsoft-Event", "Microsoft-Syslog", "Microsoft-W3CIISLog"]
        destinations = ["ws-test"]
      }
      destinations = {
        log_analytics = {
          workspace_resource_id = data.azurerm_log_analytics_workspace.law.id
          name                  = "ws-test"
        }
      }
    }
  ]
  associations = [
    {
      target_resource_id = "resource-id-of-vm-or-azure-arc-machine"
    }
  ]
}
