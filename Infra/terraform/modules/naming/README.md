<!-- BEGIN_TF_DOCS -->

## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name                                                                    | Source              | Version |
| ----------------------------------------------------------------------- | ------------------- | ------- |
| <a name="module_location_map"></a> [location_map](#module_location_map) | ../location_mapping | n/a     |

## Resources

No resources.

## Inputs

| Name                                                                     | Description               | Type     | Default | Required |
| ------------------------------------------------------------------------ | ------------------------- | -------- | ------- | :------: |
| <a name="input_env"></a> [env](#input_env)                               | Environment shortname     | `string` | n/a     |   yes    |
| <a name="input_location"></a> [location](#input_location)                | The Azure Region          | `string` | n/a     |   yes    |
| <a name="input_name"></a> [name](#input_name)                            | Base name of the resource | `string` | n/a     |   yes    |
| <a name="input_resource_type"></a> [resource_type](#input_resource_type) | Type of resource          | `string` | n/a     |   yes    |

## Outputs

| Name                                                        | Description |
| ----------------------------------------------------------- | ----------- |
| <a name="output_basename"></a> [basename](#output_basename) | n/a         |
| <a name="output_name"></a> [name](#output_name)             | n/a         |

<!-- END_TF_DOCS -->
