param location string
param location_shortname string
param environment_name string

param databricks_workspaces array

module databricks_helper '../databricks/databricks_helper.bicep' =  [for databricks_workspace in databricks_workspaces: {
  name: 'databricks_helper_${databricks_workspace.workspace_name}_workspace_deployment'
  params: {
    environment_name: environment_name
    databricks_workspace_basename: databricks_workspace.workspace_name
  }
}]

module databricks_workspaces_mod './databricks_workspace.bicep' = [for (databricks_workspace_config, idx) in databricks_workspaces: {
  name: 'databricks_workspace_${databricks_workspace_config.workspace_name}'
  params: {
    location: location
    location_shortname: location_shortname
    environment_name: environment_name
    databricks_workspace_name: databricks_helper[idx].outputs.databricks_workspace_name
    databricks_workspace_config: databricks_workspace_config
    databricks_managed_resource_group_id: databricks_helper[idx].outputs.databricks_managed_resource_group_id
    databricks_key_vault_basename: databricks_helper[idx].outputs.databricks_key_vault_basename
  }
}]
