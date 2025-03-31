param location string

param environment_name string

param databricks_workspaces array
param function_apps array
param data_factories_with_role_assignments array

var location_shortname = loadJsonContent('../../common_variables.json', 'location_shortnames')[location]

module databricks_helper '../../databricks/databricks_helper.bicep' = [for databricks_workspace in databricks_workspaces: {
  name: 'databricks_helper_${databricks_workspace.workspace_name}_role_assignment'
  params: {
    environment_name: environment_name
    databricks_workspace_basename: databricks_workspace.workspace_name
  }
}]

module databricks_role_assignments './databricks/databricks_role_assignments_handler.bicep' = [for (databricks_workspace, idx) in databricks_workspaces: {
  name: 'databricks_role_assignments_${databricks_workspace.workspace_name}'
  params: {
    location_shortname: location_shortname
    environment_name: environment_name
    key_vault_name: databricks_helper[idx].outputs.databricks_key_vault_name
    databricks_managed_resource_group_name: databricks_helper[idx].outputs.databricks_managed_resource_group_name
    databricks_workspace_name: databricks_helper[idx].outputs.databricks_workspace_name
  }
}]

module function_app_role_assignments './function_app/function_app_role_assignments_handler.bicep' = [for function_app in function_apps: {
  name: 'function_app_role_assignments_${function_app.name}'
  params: {
    environment_name: environment_name
    function_app_name: '${function_app.name}-${environment_name}'
    function_app_storage_account_name: '${function_app.storageAccountName}${environment_name}'
  }
}]

// TODO standardize ADF / Storage names below to include environment
module data_factory_role_assignments './data_factory/data_factory_role_assignments_handler.bicep' = [for data_factory in data_factories_with_role_assignments: {
  name: 'data_factory_role_assignments_${data_factory.name}'
  params: {
    environment_name: environment_name
    data_factory_name: '${data_factory.name}'
    data_factory_subscription_id: data_factory.subscription_id
    data_factory_resource_group_name: data_factory.resource_group_name
    data_factory_storage_account_name: data_factory.storageAccountName
    data_factory_storage_service_name: data_factory.?storageServiceName ?? 'default'
    data_factory_storage_container_name: data_factory.?storageContainerName ?? ''
  }
}]
