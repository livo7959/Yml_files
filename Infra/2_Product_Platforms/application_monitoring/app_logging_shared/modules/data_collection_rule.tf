# dcr collects timestamp|loglevel|rawdata(json)
module "dcr_lhapps" {
  source                      = "git::https://azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/infrastructure//0_Global_Library/terraform-modules/data-collection-rule?depth=1&ref=data-collection-rule-1.0.2"
  resource_group              = module.rg_lh_app_logging.resource_group_name
  name                        = "lhapps"
  location                    = "eus"
  environment                 = "prod"
  data_collection_endpoint_id = module.data_collection_endpoint.data_collection_endpoint_id
  collection_rules = [
    {
      data_sources = {
        log_file = {
          file_patterns = [
            # LH-Connect & LH-Services logs on BEDPOPS001
            "D:\\LogixLogs\\*.log",
            # LogixNCV, LogixCodify Web, Express Web, & Codify App on BEDPWEBICER001-004/BEDPAPPICER001-004
            "C:\\LogixLogs\\*.log"
          ]
          format                        = "text"
          streams                       = ["Custom-${azapi_resource.dcr_lhapps.name}"]
          record_start_timestamp_format = "ISO 8601"
        }
      }
      data_flow = {
        streams       = ["Custom-${azapi_resource.dcr_lhapps.name}"]
        destinations  = ["log-lhapps-eus-shared"]
        transform_kql = "source | parse RawData with TimeStamp \" | \" LogLevel \" | \" Message | project RawData, TimeStamp, LogLevel, Message, TimeGenerated"
        output_stream = "Custom-${azapi_resource.dcr_lhapps.name}"
      }
      destinations = {
        log_analytics = {
          workspace_resource_id = module.log_analytics_workspace.resource_id
          name                  = "log-lhapps-eus-shared"
        }
      }
    }
  ]
  stream_declaration = [
    {
      stream_name = "Custom-${azapi_resource.dcr_lhapps.name}"
      columns = [
        {
          name = "TimeGenerated"
          type = "datetime"
        },
        {
          name = "RawData"
          type = "string"
        }
      ]
    }
  ]
  associations = [
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDPOPS001"
    },
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDUSAAS001"
    },
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDDSVC001"
    },
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDDSAAS001"
    },
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDPCV001"
    },
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDPCV002"
    },
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDPCV003"
    },
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDPCV004"
    },
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDPCV005"
    },
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDPWEBICER001"
    },
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDPWEBICER002"
    },
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDPWEBICER003"
    },
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDPWEBICER004"
    },
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDPAPPICER001"
    },
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDPAPPICER002"
    },
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDPAPPICER003"
    },
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDPAPPICER004"
    },
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDPSAAS001"
    }
  ]
}

# dcr collects [timestamp loglevel] message
module "dcr_lhapps_sqbrm" {
  source                      = "git::https://azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/infrastructure//0_Global_Library/terraform-modules/data-collection-rule?depth=1&ref=data-collection-rule-1.0.2"
  resource_group              = module.rg_lh_app_logging.resource_group_name
  name                        = "lhappssqbrm" #square brackets then message
  location                    = "eus"
  environment                 = "prod"
  data_collection_endpoint_id = module.data_collection_endpoint.data_collection_endpoint_id
  collection_rules = [
    {
      data_sources = {
        log_file = {
          file_patterns = [
            #LogixHealth Claim Appeal Services
            "D:\\AzureDevOps\\WindowsServices\\Billing\\LogixHealth.WorkerService.ClaimsAppeal\\Logs\\*.txt",
            #LogixAvailityFileWatcher
            "D:\\AzureDevOps\\WindowsServices\\Billing\\LogixHealthDataExchangeFileWatcherNEW\\Release\\LogixFileWatcher\\Logs\\*.txt"
          ]
          format                        = "text"
          streams                       = ["Custom-${azapi_resource.dcr_lhapps.name}"]
          record_start_timestamp_format = "ISO 8601"
        }
      }
      data_flow = {
        streams       = ["Custom-${azapi_resource.dcr_lhapps.name}"]
        destinations  = ["log-lhapps-eus-shared"]
        transform_kql = "source | parse RawData with \"[\" TimeStamp\"  \" LogLevel \"]  \" Message | project RawData, TimeStamp, LogLevel, Message, TimeGenerated"
        output_stream = "Custom-${azapi_resource.dcr_lhapps.name}"
      }
      destinations = {
        log_analytics = {
          workspace_resource_id = module.log_analytics_workspace.resource_id
          name                  = "log-lhapps-eus-shared"
        }
      }
    }
  ]
  stream_declaration = [
    {
      stream_name = "Custom-${azapi_resource.dcr_lhapps.name}"
      columns = [
        {
          name = "TimeGenerated"
          type = "datetime"
        },
        {
          name = "RawData"
          type = "string"
        }
      ]
    }
  ]
  associations = [
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDPSVC001"
    }
  ]
}

# dcr collects rawdata only
module "dcr_lhapps_rawdata" {
  source                      = "git::https://azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/infrastructure//0_Global_Library/terraform-modules/data-collection-rule?depth=1&ref=data-collection-rule-1.0.2"
  resource_group              = module.rg_lh_app_logging.resource_group_name
  name                        = "lhappsrd" # raw data
  location                    = "eus"
  environment                 = "prod"
  data_collection_endpoint_id = module.data_collection_endpoint.data_collection_endpoint_id
  collection_rules = [
    {
      data_sources = {
        log_file = {
          file_patterns = [
            # Integrator Automation Engine Logs on BEDPAUTOENG01
            "D:\\IntegrationServices\\AppData\\Logs\\*.txt",
            # Logs for Microservices: AMS, CMS, CPM, CRM, IAM, Notify, Refunds, ReportingDM,
            "C:\\Logs\\log*.json",
            # Logs for billing.microsvc.logixhealth.com\Appeal on BEDPSVC001/002
            "D:\\AzureDevOps\\APIServices\\Microservice\\Billing\\Release\\Appeal\\Logs\\log*.txt",
            # Logs for billing.microsvc.logixhealth.com\Availity on BEDPSVC001/002
            "D:\\AzureDevOps\\APIServices\\Microservice\\Billing\\Release\\Availity\\Logs\\log-*.txt",
            # Logs for billing.orchsvc.logixhealth.com\Appeal on BEDPSVC001/002
            "D:\\AzureDevOps\\APIServices\\Orchestration\\Billing\\Release\\Orch_Billing_Appeal\\Logs\\log-*.txt",
            # Logs for billing.orchsvc.logixhealth.com\Availity on BEDPSVC001/002
            "D:\\AzureDevOps\\APIServices\\Orchestration\\Billing\\Release\\Availity\\Logs\\log-*.txt",
            # Logs for mobilepay.microsvc.logixhealth.com on BEDPSVC001/002
            "D:\\TFS\\MicroServices\\Atomic\\MobilePay\\Release\\MobilePayAPI\\Logs\\log-*.json",
            # Logs for Eligibility, ClaimStatus, Projection on BEDPWEBBILL001/APP001
            "D:\\LogixLogs\\log-*.txt",
            # Logs for Denials on BEDPWEBBILL001/APP001
            "D:\\LogixLogs\\log-*.json",
            # Logs for LogixPaidRight on BEDPWEBBILL001/APP001
            "D:\\TFS\\Release\\LogixPaidRight\\Logs\\LogixPaidRight*.log",
            # Logs for MobilePay Windows Service on BEDPAPPBILL001
            "D:\\AzureDevOps\\MobilePayWorkerService\\Release\\LogixHealth.MobilePay\\Logs\\logs-*.json",
            # Logs for LogixSweepAutomated Windows Service on BEDPAPPBILL001
            "C:\\LogixLogs\\AutomatedSweepProcess\\log-*.txt",
            # Logs for LogixEDI835Parser Windows Service on BEDPAPPBILL001
            "D:\\AzureDevOps\\EDI835ImportWorkerService\\Release\\EDI835Import.WorkerService\\Logs\\log-*.txt",
            # Logs for LogixHealth Corp Website on BEDPOPS001
            "C:\\LogixHealthSiteApi\\Error*.txt"
          ]
          format                        = "text"
          streams                       = ["Custom-${azapi_resource.dcr_lhapps.name}"]
          record_start_timestamp_format = "ISO 8601"
        }
      }
      data_flow = {
        streams       = ["Custom-${azapi_resource.dcr_lhapps.name}"]
        destinations  = ["log-lhapps-eus-shared"]
        transform_kql = "source"
        output_stream = "Custom-${azapi_resource.dcr_lhapps.name}"
      }
      destinations = {
        log_analytics = {
          workspace_resource_id = module.log_analytics_workspace.resource_id
          name                  = "log-lhapps-eus-shared"
        }
      }
    }
  ]
  stream_declaration = [
    {
      stream_name = "Custom-${azapi_resource.dcr_lhapps.name}"
      columns = [
        {
          name = "TimeGenerated"
          type = "datetime"
        },
        {
          name = "RawData"
          type = "string"
        }
      ]
    }
  ]
  associations = [
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-servers/providers/Microsoft.HybridCompute/machines/BEDPAUTOENG01"
    },
    {
      name               = "configurationAccessEndpoint2"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDPSVC001"
    },
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDPSVC002"
    },

    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDPWEBBILL001"
    },
    {
      name               = "configurationAccessEndpoint"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDPAPPBILL001"
    },
    {
      name               = "configurationAccessEndpoint2"
      target_resource_id = "/subscriptions/fa5c2028-2067-4378-a45a-e3cc445f532b/resourceGroups/rg-azure-arc-webapp-servers/providers/Microsoft.HybridCompute/machines/BEDPOPS001"
    }
  ]
}
