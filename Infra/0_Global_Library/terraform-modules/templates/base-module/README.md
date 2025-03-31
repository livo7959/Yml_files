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

| Name                                                                                                            | Type     |
| --------------------------------------------------------------------------------------------------------------- | -------- |
| [azurerm_example.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/example) | resource |

## Inputs

| Name                                                                                       | Description                                                                                                         | Type          | Default | Required |
| ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------- | ------------- | ------- | :------: |
| <a name="input_environment"></a> [environment](#input_environment)                         | Environment shortname                                                                                               | `string`      | n/a     |   yes    |
| <a name="input_location"></a> [location](#input_location)                                  | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created | `string`      | n/a     |   yes    |
| <a name="input_name"></a> [name](#input_name)                                              | The name of the example resource                                                                                    | `string`      | n/a     |   yes    |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name) | Name of the resource group. Should be in the format of: `rg-foo`                                                    | `string`      | n/a     |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)                                              | A mapping of tags to assign to the resource                                                                         | `map(string)` | `{}`    |    no    |

## Outputs

| Name                                                     | Description               |
| -------------------------------------------------------- | ------------------------- |
| <a name="output_example"></a> [example](#output_example) | This is an example output |

<!-- END_TF_DOCS -->
