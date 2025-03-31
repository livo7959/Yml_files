param environment_name string

param data_factory_name string
param data_factory_subscription_id string
param data_factory_resource_group_name string
param data_factory_storage_account_name string
param data_factory_storage_service_name string
param data_factory_storage_container_name string

resource data_factory_resource 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: data_factory_name
  scope: resourceGroup(data_factory_subscription_id, data_factory_resource_group_name)
}

// Storage Blob Data Contributor https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor
var role_def_id = resourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
var principal_id = data_factory_resource.identity.principalId

module data_factory_role_assignment 'data_factory_role_assignments.bicep' = {
  name: 'data_factory_role_asnmnt_blob_data_cont_${data_factory_name}'
  params: {
    role_assignment_name: guid(
      'Storage Blob Data Contributor',
      role_def_id,
      data_factory_name,
      data_factory_storage_container_name,
      environment_name,
      principal_id
    )
    role_def_id: role_def_id
    principal_id: principal_id
    data_factory_storage_account_name: data_factory_storage_account_name
    data_factory_storage_service_name: data_factory_storage_service_name
    data_factory_storage_container_name: data_factory_storage_container_name
  }
}
