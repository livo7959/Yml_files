<!-- BEGIN_TF_DOCS -->

## Requirements

No requirements.

## Providers

| Name                                                         | Version |
| ------------------------------------------------------------ | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) | n/a     |

## Modules

| Name                                                                                | Source              | Version |
| ----------------------------------------------------------------------------------- | ------------------- | ------- |
| <a name="module_common_constants"></a> [common_constants](#module_common_constants) | ../common/constants | n/a     |

## Resources

| Name                                                                                                                                                                              | Type     |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azurerm_monitor_data_collection_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_endpoint)                 | resource |
| [azurerm_monitor_data_collection_rule_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule_association) | resource |

## Inputs

| Name                                                                                                                     | Description                                                                                                                                                                                                                                                   | Type                                                                                                                   | Default | Required |
| ------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ------- | :------: |
| <a name="input_associations"></a> [associations](#input_associations)                                                    | Data Collection Endpoint resource associations. These are the target resource IDs where the rules will be applied.                                                                                                                                            | <pre>list(object({<br/> target_resource_id = string<br/> data_collection_endpoint_id = optional(string)<br/> }))</pre> | `[]`    |    no    |
| <a name="input_environment"></a> [environment](#input_environment)                                                       | Environment shortname                                                                                                                                                                                                                                         | `string`                                                                                                               | n/a     |   yes    |
| <a name="input_kind"></a> [kind](#input_kind)                                                                            | Default is null - which allows Windows and Linux, possible values are `Windows` and ` Linux`.                                                                                                                                                                 | `string`                                                                                                               | `null`  |    no    |
| <a name="input_location"></a> [location](#input_location)                                                                | Azure region short name (CAF). e.g. `eus` for East US. See: https://www.jlaundry.nz/2022/azure_region_abbreviations/                                                                                                                                          | `string`                                                                                                               | n/a     |   yes    |
| <a name="input_name"></a> [name](#input_name)                                                                            | A name describing what the data collection endpoint is for. Note that the real name of the resource will have the location and the environment appended to it. The provided name should be all lowercase and one word. e.g. `avd` (for Azure Virtual Desktop) | `string`                                                                                                               | n/a     |   yes    |
| <a name="input_public_network_access_enabled"></a> [public_network_access_enabled](#input_public_network_access_enabled) | Whether or not public access is enabled for the DCE. Default is true. False will require AMPLS (Private Link) and/or other Network Isolation configurations.                                                                                                  | `bool`                                                                                                                 | `true`  |    no    |
| <a name="input_resource_group"></a> [resource_group](#input_resource_group)                                              | Name of the resource group that the data collection endpoint should be in. Should be in the format of: `rg-foo`                                                                                                                                               | `string`                                                                                                               | n/a     |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                            | Tags for the deployment. Tag names are case insensitive, but tag values are case sensitive. The `managedBy = "terraform"` tag will automatically be applied in addition to any other tags specified.                                                          | `map(string)`                                                                                                          | `{}`    |    no    |

## Outputs

| Name                                                                                                                       | Description                                  |
| -------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| <a name="output_data_collection_endpoint_id"></a> [data_collection_endpoint_id](#output_data_collection_endpoint_id)       | Resource ID of the data collection endpoint. |
| <a name="output_data_collection_endpoint_name"></a> [data_collection_endpoint_name](#output_data_collection_endpoint_name) | Name of the data collection endpoint.        |

<!-- END_TF_DOCS -->
