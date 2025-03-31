<!-- BEGIN_TF_DOCS -->

# `container-app-environment`

This is an internal [Terraform](https://www.terraform.io/) module to create a [Container App Environment ](https://learn.microsoft.com/en-us/azure/container-apps/environment) in [Microsoft Azure](https://azure.microsoft.com/en-us).

## Requirements

| Name                                                                     | Version  |
| ------------------------------------------------------------------------ | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >=1.9.0  |
| <a name="requirement_azurerm"></a> [azurerm](#requirement_azurerm)       | >=4.13.0 |

## Providers

| Name                                                         | Version |
| ------------------------------------------------------------ | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) | 4.13.0  |

## Modules

| Name                                                                                | Source              | Version |
| ----------------------------------------------------------------------------------- | ------------------- | ------- |
| <a name="module_common_constants"></a> [common_constants](#module_common_constants) | ../common/constants | n/a     |

## Resources

| Name                                                                                                                                                | Type     |
| --------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azurerm_container_app_environment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment) | resource |

## Inputs

| Name                                                                                                                                 | Description                                                                                                                                                                                                                                                                                                                                             | Type                                                                                                                                       | Default | Required |
| ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ | ------- | :------: |
| <a name="input_environment"></a> [environment](#input_environment)                                                                   | Environment shortname                                                                                                                                                                                                                                                                                                                                   | `string`                                                                                                                                   | n/a     |   yes    |
| <a name="input_infrastructure_resouce_group_name"></a> [infrastructure_resouce_group_name](#input_infrastructure_resouce_group_name) | Name of the platform-managed resource group created for the Managed Environment to host infrastructure resources. Changing this forces a new resource to be created. Only valid if a workload_profile is specified. If infrastructure_subnet_id is specified, this resource group will be created in the same subscription as infrastructure_subnet_id. | `string`                                                                                                                                   | `null`  |    no    |
| <a name="input_infrastructure_subnet_id"></a> [infrastructure_subnet_id](#input_infrastructure_subnet_id)                            | The existing Subnet to use for the Container Apps Control Plane. Changing this forces a new resource to be created. The Subnet must have a /21 or larger address space                                                                                                                                                                                  | `string`                                                                                                                                   | `null`  |    no    |
| <a name="input_internal_load_balancer_enabled"></a> [internal_load_balancer_enabled](#input_internal_load_balancer_enabled)          | Should the Container Environment operate in Internal Load Balancing Mode? Defaults to false. Changing this forces a new resource to be created. Can only be set to true if infrastructure_subnet_id is specified                                                                                                                                        | `bool`                                                                                                                                     | `null`  |    no    |
| <a name="input_location"></a> [location](#input_location)                                                                            | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created                                                                                                                                                                                                                                     | `string`                                                                                                                                   | n/a     |   yes    |
| <a name="input_name"></a> [name](#input_name)                                                                                        | The name of the Container Apps Managed Environment. Changing this forces a new resource to be created                                                                                                                                                                                                                                                   | `string`                                                                                                                                   | n/a     |   yes    |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name)                                           | Name of the resource group that the Container App Environment should be in. Should be in the format of: `rg-foo`                                                                                                                                                                                                                                        | `string`                                                                                                                                   | n/a     |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                                        | A mapping of tags to assign to the resource                                                                                                                                                                                                                                                                                                             | `map(string)`                                                                                                                              | `{}`    |    no    |
| <a name="input_workload_profile"></a> [workload_profile](#input_workload_profile)                                                    | The profile of the workload to scope the container app execution. For Workload profile type for the workloads to run on, possible values include Consumption, D4, D8, D16, D32, E4, E8, E16 and E32                                                                                                                                                     | <pre>object({<br/> name = string<br/> workload_profile_type = string<br/> maximum_count = number<br/> minimum_count = number<br/> })</pre> | `null`  |    no    |
| <a name="input_zone_redundancy_enabled"></a> [zone_redundancy_enabled](#input_zone_redundancy_enabled)                               | Should the Container App Environment be created with Zone Redundancy enabled? Defaults to false. Changing this forces a new resource to be created. can only be set to true if infrastructure_subnet_id is specified                                                                                                                                    | `bool`                                                                                                                                     | `null`  |    no    |

## Outputs

| Name                                      | Description                             |
| ----------------------------------------- | --------------------------------------- |
| <a name="output_id"></a> [id](#output_id) | The ID of the Container App Environment |

<!-- END_TF_DOCS -->
