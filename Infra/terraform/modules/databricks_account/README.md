<!-- BEGIN_TF_DOCS -->

## Requirements

No requirements.

## Providers

| Name                                                                                             | Version |
| ------------------------------------------------------------------------------------------------ | ------- |
| <a name="provider_databricks"></a> [databricks](#provider_databricks)                            | n/a     |
| <a name="provider_databricks.accounts"></a> [databricks.accounts](#provider_databricks.accounts) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                                                                                                    | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [databricks_group.databricks_account_admin](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/group)                                                                   | resource    |
| [databricks_group.databricks_admin](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/group)                                                                           | resource    |
| [databricks_group.databricks_bronze_data_writer](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/group)                                                              | resource    |
| [databricks_group.databricks_gold_data_writer](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/group)                                                                | resource    |
| [databricks_group.databricks_silver_data_writer](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/group)                                                              | resource    |
| [databricks_group_member.databricks_admin_members](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/group_member)                                                     | resource    |
| [databricks_group_member.databricks_bronze_data_writer_members](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/group_member)                                        | resource    |
| [databricks_group_member.databricks_gold_data_writer_members](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/group_member)                                          | resource    |
| [databricks_group_member.databricks_silver_data_writer_members](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/group_member)                                        | resource    |
| [databricks_group_role.databricks_account_admin](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/group_role)                                                         | resource    |
| [databricks_metastore.dbx_metastore](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/metastore)                                                                      | resource    |
| [databricks_metastore_assignment.metastore_workspace_assignment](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/metastore_assignment)                               | resource    |
| [databricks_mws_permission_assignment.workspace_admin](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/mws_permission_assignment)                                    | resource    |
| [databricks_mws_permission_assignment.workspace_user](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/mws_permission_assignment)                                     | resource    |
| [databricks_mws_permission_assignment.workspace_user_group_databricks_bronze_data_writer](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/resources/mws_permission_assignment) | resource    |
| [databricks_group.analytics_and_innovation_data_developer](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/data-sources/group)                                                 | data source |
| [databricks_group.technology_lab](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/data-sources/group)                                                                          | data source |
| [databricks_service_principal.sp-azdo-lhCorpDev001](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/data-sources/service_principal)                                            | data source |
| [databricks_service_principal.sp-azdo-lhCorpShared001](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/data-sources/service_principal)                                         | data source |
| [databricks_service_principal.spSanboxMG](https://registry.terraform.io/providers/hashicorp/databricks/latest/docs/data-sources/service_principal)                                                      | data source |

## Inputs

| Name                                                                           | Description            | Type     | Default | Required |
| ------------------------------------------------------------------------------ | ---------------------- | -------- | ------- | :------: |
| <a name="input_env"></a> [env](#input_env)                                     | Environment shortname  | `string` | n/a     |   yes    |
| <a name="input_location"></a> [location](#input_location)                      | The Azure Region       | `string` | n/a     |   yes    |
| <a name="input_subscription_id"></a> [subscription_id](#input_subscription_id) | subscription id (guid) | `string` | n/a     |   yes    |

## Outputs

No outputs.

<!-- END_TF_DOCS -->
