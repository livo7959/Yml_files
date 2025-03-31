param environment_name string
param databricks_workspace_basename string

var workspace_name = '${databricks_workspace_basename}-${environment_name}'
var key_vault_basename = 'dbk-${length(databricks_workspace_basename) <= 19 - length(environment_name) ? '${databricks_workspace_basename}' : '${substring(databricks_workspace_basename, 0, (19 - length(environment_name)))}'}'
var databricks_managed_resource_group_name = 'rg-databricks-${databricks_workspace_basename}-${uniqueString(databricks_workspace_basename, split(resourceGroup().name, '-')[1])}-${environment_name}'

output databricks_key_vault_basename string = key_vault_basename
output databricks_key_vault_name string = '${key_vault_basename}-${environment_name}'
output databricks_workspace_name string = workspace_name
output databricks_managed_resource_group_name string = databricks_managed_resource_group_name
output databricks_managed_resource_group_id string = '${subscription().id}/resourceGroups/${databricks_managed_resource_group_name}'
