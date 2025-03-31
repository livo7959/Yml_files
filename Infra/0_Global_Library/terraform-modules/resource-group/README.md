# `resource-group`

This is an internal [Terraform](https://www.terraform.io/) module to create a [resource group](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal#what-is-a-resource-group) in [Microsoft Azure](https://azure.microsoft.com/en-us).

This abstraction provides automatic naming and the ability to set a lock level.

The [auto-generated documentation](https://github.com/terraform-docs/terraform-docs) for this module is below.

## Examples

See the [examples](examples/README.md) directory.

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

| Name                                                                                                                            | Type     |
| ------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)   | resource |

## Inputs

| Name                                                               | Description                                                                                                                                                                                                                                                                                | Type          | Default | Required |
| ------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------- | ------- | :------: |
| <a name="input_environment"></a> [environment](#input_environment) | Environment shortname                                                                                                                                                                                                                                                                      | `string`      | n/a     |   yes    |
| <a name="input_location"></a> [location](#input_location)          | Azure region short name (CAF). e.g. `eus` for East US. See: https://www.jlaundry.nz/2022/azure_region_abbreviations/                                                                                                                                                                       | `string`      | n/a     |   yes    |
| <a name="input_lock_level"></a> [lock_level](#input_lock_level)    | Lock level of the resource group. Possible values are `CanNotDelete` and `ReadOnly`. `CanNotDelete` means authorized users are able to read and modify the resources, but not delete. `ReadOnly` means authorized users can only read from a resource, but they can't modify or delete it. | `string`      | `""`    |    no    |
| <a name="input_name"></a> [name](#input_name)                      | A name describing what the resource group is for. Note that the real name of the resource will have the location and the environment appended to it. The provided name should be all lowercase and one word. e.g. `avd` (for Azure Virtual Desktop)                                        | `string`      | n/a     |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)                      | Tags for the deployment. Tag names are case insensitive, but tag values are case sensitive. The `managedBy = "terraform"` tag will automatically be applied in addition to any other tags specified.                                                                                       | `map(string)` | `{}`    |    no    |

## Outputs

| Name                                                                                                     | Description           |
| -------------------------------------------------------------------------------------------------------- | --------------------- |
| <a name="output_resource_group_id"></a> [resource_group_id](#output_resource_group_id)                   | Resource group id     |
| <a name="output_resource_group_location"></a> [resource_group_location](#output_resource_group_location) | Resource group region |
| <a name="output_resource_group_name"></a> [resource_group_name](#output_resource_group_name)             | Resource group name   |

<!-- END_TF_DOCS -->
