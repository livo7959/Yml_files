<!-- BEGIN_TF_DOCS -->

# `action-group`

This is an internal [Terraform](https://www.terraform.io/) module to create an [Action group ](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups) in [Microsoft Azure](https://azure.microsoft.com/en-us).

This module supports:

- Creating an Action Group with multiple email recipients

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

| Name                                                                                | Source                 | Version |
| ----------------------------------------------------------------------------------- | ---------------------- | ------- |
| <a name="module_common_constants"></a> [common_constants](#module_common_constants) | ../../common/constants | n/a     |

## Resources

| Name                                                                                                                                      | Type     |
| ----------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azurerm_monitor_action_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |

## Inputs

| Name                                                                                       | Description                                                                                                          | Type                                                                             | Default | Required |
| ------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- | ------- | :------: |
| <a name="input_email_receivers"></a> [email_receivers](#input_email_receivers)             | The name of the email receivers                                                                                      | <pre>list(object({<br/> email_address = string<br/> name = string<br/> }))</pre> | `[]`    |    no    |
| <a name="input_location"></a> [location](#input_location)                                  | Azure region short name (CAF). e.g. `eus` for East US. See: https://www.jlaundry.nz/2022/azure_region_abbreviations/ | `string`                                                                         | n/a     |   yes    |
| <a name="input_name"></a> [name](#input_name)                                              | Name of the action group                                                                                             | `string`                                                                         | n/a     |   yes    |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name) | Name of the resource group                                                                                           | `string`                                                                         | n/a     |   yes    |
| <a name="input_short_name"></a> [short_name](#input_short_name)                            | Short name for the action group, used for SMS messages                                                               | `string`                                                                         | n/a     |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)                                              | Tags of the action group resource                                                                                    | `map(string)`                                                                    | `{}`    |    no    |

## Outputs

| Name                                                                             | Description        |
| -------------------------------------------------------------------------------- | ------------------ |
| <a name="output_action_group_id"></a> [action_group_id](#output_action_group_id) | ID of action group |

<!-- END_TF_DOCS -->
