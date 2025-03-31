module "private_endpoints" {
  source = "../../../../0_Global_Library/infrastructure_templates/terraform/networking/private_endpoint_hub"
  endpoints = [
    {
      name              = "pep-web-auth-eus-shared"
      subnet_name       = "snet-pe-shared-https-eus-001"
      vnet_name         = "vnet-private-endpoint-eus-001"
      subresource_names = ["browser_authentication"]
      target_resource   = "/subscriptions/4cd6ebc5-58d1-40fc-98dc-8645df2ffcc4/resourceGroups/rg-databricks-shared/providers/Microsoft.Databricks/workspaces/web-auth-eus-shared"
      dns_zone          = "privatelink.azuredatabricks.net"
      env               = "shared"
      tags = {
        environment = "shared"
        managedBy   = "terraform"
      }
      is_manual_connection = false
    },
    {
      name              = "pep-adf-logix-data-sbox"
      subnet_name       = "snet-pe-shared-https-eus-001"
      vnet_name         = "vnet-private-endpoint-eus-001"
      subresource_names = ["dataFactory"]
      target_resource   = "/subscriptions/8192a5d8-1a56-4caf-b961-0eae16cbd1d3/resourceGroups/rg-data-sbox/providers/Microsoft.DataFactory/factories/logix-data-sbox"
      dns_zone          = "privatelink.datafactory.azure.net"
      env               = "sbox"
      tags = {
        environment = "sbox"
        managedBy   = "terraform"
      }
      is_manual_connection = false
    },
    {
      name              = "pep-logix-data-fe-sbox"
      subnet_name       = "snet-pe-shared-https-eus-001"
      vnet_name         = "vnet-private-endpoint-eus-001"
      subresource_names = ["databricks_ui_api"]
      target_resource   = "/subscriptions/8192a5d8-1a56-4caf-b961-0eae16cbd1d3/resourceGroups/rg-databricks-sbox/providers/Microsoft.Databricks/workspaces/logix-data-sbox"
      dns_zone          = "privatelink.azuredatabricks.net"
      env               = "shared"
      tags = {
        environment = "sbox"
        managedBy   = "terraform"
      }
      is_manual_connection = false
    },
    {
      name              = "pep-adf-logix-data-stg"
      subnet_name       = "snet-pe-shared-https-eus-001"
      vnet_name         = "vnet-private-endpoint-eus-001"
      subresource_names = ["dataFactory"]
      target_resource   = "/subscriptions/bf6bb924-c903-43e9-9e06-2c2d2c605d1a/resourceGroups/rg-data-stg/providers/Microsoft.DataFactory/factories/logix-data-stg"
      dns_zone          = "privatelink.datafactory.azure.net"
      env               = "stg"
      tags = {
        environment = "stg"
        managedBy   = "terraform"
      }
      is_manual_connection = false
    }
  ]
}
