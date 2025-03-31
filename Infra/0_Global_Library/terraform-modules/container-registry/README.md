# `container-app-registry`

This is an internal [Terraform](https://www.terraform.io/) module to create a [Container App Registry ](https://learn.microsoft.com/en-us/azure/container-registry/) in [Microsoft Azure](https://azure.microsoft.com/en-us).

## Naming Convention

Azure enforces the use of only alphanumeric characters in the name of a Azure Container Registry. As a result, we cannot include dashes, which are part of our standard naming convention for Azure resources. Additionally, in alignment with [Microsoft's abbreviation recommendations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations), we are prefixing 'lhcr' instead of just 'cr' to ensure the name is globally unique, as required for an Azure Container Registry. Furthermore, since these registries can be geo-replicated, we have opted not to include the resource location in the name to avoid potential confusion.

<!-- BEGIN_TF_DOCS -->

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

| Name                                                                                                                                  | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azurerm_container_registry.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |

## Inputs

| Name                                                                                                                     | Description                                                                                                                                                                              | Type                                                                                                                                                                                                   | Default           | Required |
| ------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------- | :------: |
| <a name="input_admin_enabled"></a> [admin_enabled](#input_admin_enabled)                                                 | Specifies whether the admin user is enabled                                                                                                                                              | `bool`                                                                                                                                                                                                 | `false`           |    no    |
| <a name="input_environment"></a> [environment](#input_environment)                                                       | Environment shortname                                                                                                                                                                    | `string`                                                                                                                                                                                               | n/a               |   yes    |
| <a name="input_georeplications"></a> [georeplications](#input_georeplications)                                           | List of geo-replication locations for the container registry. Only supported on new resources with the Premium SKU. Also cannot contain the location where the Container Registry exists | <pre>list(object({<br/> location = string<br/> regional_endpoint_enabled = optional(bool, false)<br/> zone_redundancy_enabled = optional(bool, false)<br/> tags = optional(map(string))<br/> }))</pre> | `null`            |    no    |
| <a name="input_identity"></a> [identity](#input_identity)                                                                | Identity                                                                                                                                                                                 | <pre>list(object({<br/> type = string<br/> identity_ids = optional(set(string), null)<br/> }))</pre>                                                                                                   | `null`            |    no    |
| <a name="input_location"></a> [location](#input_location)                                                                | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created                                                                      | `string`                                                                                                                                                                                               | n/a               |   yes    |
| <a name="input_name"></a> [name](#input_name)                                                                            | Specifies the name of the Container Registry. Only Alphanumeric characters allowed. Changing this forces a new resource to be created                                                    | `string`                                                                                                                                                                                               | n/a               |   yes    |
| <a name="input_network_rule_bypass_option"></a> [network_rule_bypass_option](#input_network_rule_bypass_option)          | Whether to allow trusted Azure services to access a network restricted Container Registry                                                                                                | `string`                                                                                                                                                                                               | `"AzureServices"` |    no    |
| <a name="input_network_rule_set"></a> [network_rule_set](#input_network_rule_set)                                        | Network rules                                                                                                                                                                            | <pre>list(object({<br/> default_action = optional(string)<br/> ip_rule = optional(list(object({<br/> action = string<br/> ip_range = string<br/> })), [])<br/> }))</pre>                               | `null`            |    no    |
| <a name="input_public_network_access_enabled"></a> [public_network_access_enabled](#input_public_network_access_enabled) | Whether public network access is allowed for the container registry                                                                                                                      | `bool`                                                                                                                                                                                                 | `true`            |    no    |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name)                               | The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created                                                              | `string`                                                                                                                                                                                               | n/a               |   yes    |
| <a name="input_sku"></a> [sku](#input_sku)                                                                               | The SKU name of the container registry                                                                                                                                                   | `string`                                                                                                                                                                                               | n/a               |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                            | A mapping of tags to assign to the resource                                                                                                                                              | `map(string)`                                                                                                                                                                                          | `{}`              |    no    |
| <a name="input_zone_redundancy_enabled"></a> [zone_redundancy_enabled](#input_zone_redundancy_enabled)                   | Whether zone redundancy is enabled for this container registry                                                                                                                           | `bool`                                                                                                                                                                                                 | `false`           |    no    |

## Outputs

| Name                                                                    | Description                                                 |
| ----------------------------------------------------------------------- | ----------------------------------------------------------- |
| <a name="output_id"></a> [id](#output_id)                               | The ID of the container registry                            |
| <a name="output_login_server"></a> [login_server](#output_login_server) | The URL that can be used to log into the container registry |

<!-- END_TF_DOCS -->
