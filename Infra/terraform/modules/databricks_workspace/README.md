<!-- BEGIN_TF_DOCS -->

## Requirements

No requirements.

## Providers

| Name                                                                  | Version |
| --------------------------------------------------------------------- | ------- |
| <a name="provider_databricks"></a> [databricks](#provider_databricks) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                                             | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [databricks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/cluster)                         | resource    |
| [databricks_cluster_policy.custom_policies](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/cluster_policy)   | resource    |
| [databricks_job.databricks_jobs](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/job)                         | resource    |
| [databricks_permissions.cluster_usage](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/permissions)           | resource    |
| [databricks_permissions.dlt_pipeline_usage](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/permissions)      | resource    |
| [databricks_permissions.job_usage](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/permissions)               | resource    |
| [databricks_pipeline.dlt_pipelines](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/pipeline)                 | resource    |
| [databricks_secret_scope.keyvault_secret_scope](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/secret_scope) | resource    |
| [databricks_group.databricks_bronze_data_writer](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/data-sources/group)    | data source |
| [databricks_node_type.smallest](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/data-sources/node_type)                 | data source |
| [databricks_spark_version.latest_lts](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/data-sources/spark_version)       | data source |

## Inputs

| Name                                                                                                | Description                              | Type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | Default | Required |
| --------------------------------------------------------------------------------------------------- | ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | :------: |
| <a name="input_cluster_configurations"></a> [cluster_configurations](#input_cluster_configurations) | compute cluster configurations           | <pre>list(object({<br> name = string<br> spark_version = optional(string, null)<br> node_type_id = optional(string, null)<br> autotermination_minutes = number<br> max_workers = number<br> }))</pre>                                                                                                                                                                                                                                                                                           | n/a     |   yes    |
| <a name="input_cluster_policies"></a> [cluster_policies](#input_cluster_policies)                   | compute cluster policies                 | <pre>list(object({<br> name = string<br> description = string<br> definition = object({<br> cluster_type = object({<br> type = string<br> value = string<br> })<br> num_workers = optional(object({<br> type = string<br> defaultValue = number<br> maxValue = number<br> isOptional = bool<br> }))<br> node_type_id = optional(object({<br> type = string<br> isOptional = bool<br> }))<br> spark_version = optional(object({<br> type = string<br> hidden = bool<br> }))<br> })<br> }))</pre> | n/a     |   yes    |
| <a name="input_dlt_pipelines"></a> [dlt_pipelines](#input_dlt_pipelines)                            | Delta Live Table Pipeline configurations | <pre>list(object({<br> name = string<br> target = string<br> continuous = bool<br> development = bool<br> photon = bool<br> channel = string<br> edition = string<br> notebook_path = string<br> cluster = object({<br> policy = string<br> num_workers = optional(number, 1)<br> node_type_id = optional(string)<br> driver_node_type_id = optional(string)<br> })<br> }))</pre>                                                                                                               | n/a     |   yes    |
| <a name="input_env"></a> [env](#input_env)                                                          | Environment shortname                    | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | n/a     |   yes    |
| <a name="input_job_configurations"></a> [job_configurations](#input_job_configurations)             | Databricks job configurations            | <pre>list(object({<br> name = string<br> description = string<br> tasks = map(object({<br> pipeline_task = optional(object({<br> pipeline_name = string<br> }))<br> notebook_task = optional(object({<br> notebook_name = string<br> }))<br> dependencies = optional(list(string), [])<br> }))<br> }))</pre>                                                                                                                                                                                    | n/a     |   yes    |
| <a name="input_key_vault_id"></a> [key_vault_id](#input_key_vault_id)                               | ID for keyvault to create secret scope   | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | n/a     |   yes    |
| <a name="input_key_vault_uri"></a> [key_vault_uri](#input_key_vault_uri)                            | DNS for keyvault used for secret scope   | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | n/a     |   yes    |
| <a name="input_subscription_id"></a> [subscription_id](#input_subscription_id)                      | subscription id (guid)                   | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | n/a     |   yes    |
| <a name="input_tenant_id"></a> [tenant_id](#input_tenant_id)                                        | azure tentant id                         | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | n/a     |   yes    |
| <a name="input_workspace_id"></a> [workspace_id](#input_workspace_id)                               | databricks workspace id                  | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | n/a     |   yes    |

## Outputs

No outputs.

<!-- END_TF_DOCS -->
