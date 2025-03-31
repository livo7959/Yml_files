<!-- BEGIN_TF_DOCS -->

# `log-analytics-workspace`

This is an internal [Terraform](https://www.terraform.io/) module to create a [Log Analytics workspace ](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview) in [Microsoft Azure](https://azure.microsoft.com/en-us).

## Requirements

| Name                                                                     | Version |
| ------------------------------------------------------------------------ | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >=1.9.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement_azurerm)       | >=4.3.0 |

## Providers

| Name                                                         | Version |
| ------------------------------------------------------------ | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) | 4.3.0   |

## Examples

See the examples directory.

## Modules

| Name                                                                                | Source              | Version |
| ----------------------------------------------------------------------------------- | ------------------- | ------- |
| <a name="module_common_constants"></a> [common_constants](#module_common_constants) | ../common/constants | n/a     |

## Resources

| Name                                                                                                                                            | Type     |
| ----------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |

## Inputs

| Name                                                                                                                                                   | Description                                                                                                                                                                                                         | Type                                                                            | Default       | Required |
| ------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | ------------- | :------: |
| <a name="input_allow_resource_only_permissions"></a> [allow_resource_only_permissions](#input_allow_resource_only_permissions)                         | Specifies if the Log Analytics Workspace allow users accessing to data associated with resources they have permission to view, without permission to workspace                                                      | `bool`                                                                          | `false`       |    no    |
| <a name="input_cmk_for_query_forced"></a> [cmk_for_query_forced](#input_cmk_for_query_forced)                                                          | Is Customer Managed Storage mandatory for query management?                                                                                                                                                         | `bool`                                                                          | `false`       |    no    |
| <a name="input_daily_quota_gb"></a> [daily_quota_gb](#input_daily_quota_gb)                                                                            | The daily quota in GB for the Log Analytics Workspace                                                                                                                                                               | `number`                                                                        | `-1`          |    no    |
| <a name="input_data_collection_rule_id"></a> [data_collection_rule_id](#input_data_collection_rule_id)                                                 | The ID of the Data Collection Rule to use for this workspace                                                                                                                                                        | `string`                                                                        | `null`        |    no    |
| <a name="input_environment"></a> [environment](#input_environment)                                                                                     | Environment shortname                                                                                                                                                                                               | `string`                                                                        | n/a           |   yes    |
| <a name="input_identity"></a> [identity](#input_identity)                                                                                              | Identity block                                                                                                                                                                                                      | <pre>list(object({<br/> type = string<br/> identity_ids = string<br/> }))</pre> | `[]`          |    no    |
| <a name="input_immediate_data_purge_on_30_days_enabled"></a> [immediate_data_purge_on_30_days_enabled](#input_immediate_data_purge_on_30_days_enabled) | Whether to remove the data in the Log Analytics Workspace immediately after 30 days                                                                                                                                 | `bool`                                                                          | `false`       |    no    |
| <a name="input_internet_ingestion_enabled"></a> [internet_ingestion_enabled](#input_internet_ingestion_enabled)                                        | Should the Log Analytics Workspace support ingestion over the Public Internet?                                                                                                                                      | `bool`                                                                          | `true`        |    no    |
| <a name="input_internet_query_enabled"></a> [internet_query_enabled](#input_internet_query_enabled)                                                    | Should the Log Analytics Workspace support querying over the Public Internet?                                                                                                                                       | `bool`                                                                          | `true`        |    no    |
| <a name="input_local_authentication_disabled"></a> [local_authentication_disabled](#input_local_authentication_disabled)                               | Specifies if the Log Analytics Workspace should enforce authentication using Entra ID                                                                                                                               | `bool`                                                                          | `false`       |    no    |
| <a name="input_location"></a> [location](#input_location)                                                                                              | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created                                                                                                 | `string`                                                                        | n/a           |   yes    |
| <a name="input_name"></a> [name](#input_name)                                                                                                          | Specifies the name of the Log Analytics Workspace. Workspace name should include 4-63 letters, digits or '-'. The '-' shouldn't be the first or the last symbol. Changing this forces a new resource to be created. | `string`                                                                        | n/a           |   yes    |
| <a name="input_reservation_capacity_in_gb_per_day"></a> [reservation_capacity_in_gb_per_day](#input_reservation_capacity_in_gb_per_day)                | The capacity reservation level in GB for this workspace. Possible values are 100, 200, 300, 400, 500, 1000, 2000 and 5000.                                                                                          | `number`                                                                        | `null`        |    no    |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name)                                                             | The name of the resource group in which the Log Analytics workspace is created. Changing this forces a new resource to be created                                                                                   | `string`                                                                        | n/a           |   yes    |
| <a name="input_retention_in_days"></a> [retention_in_days](#input_retention_in_days)                                                                   | The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730                                                                                                     | `number`                                                                        | `null`        |    no    |
| <a name="input_sku"></a> [sku](#input_sku)                                                                                                             | Specifies the SKU of the Log Analytics Workspace. Possible values are PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new SKU as of 2018-04-03)                              | `string`                                                                        | `"PerGB2018"` |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                                                          | A mapping of tags to assign to the resource                                                                                                                                                                         | `map(string)`                                                                   | `{}`          |    no    |

## Outputs

| Name                                                                    | Description                |
| ----------------------------------------------------------------------- | -------------------------- |
| <a name="output_resource_id"></a> [resource_id](#output_resource_id)    | Log Analytics resource ID  |
| <a name="output_workspace_id"></a> [workspace_id](#output_workspace_id) | Log Analytics Workspace ID |

<!-- END_TF_DOCS -->
