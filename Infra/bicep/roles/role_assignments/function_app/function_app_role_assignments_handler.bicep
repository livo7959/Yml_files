param function_app_name string
param function_app_storage_account_name string
param environment_name string

resource function_app_resource 'Microsoft.Web/sites@2022-09-01' existing = {
  name: function_app_name
}

// Storage Blob Data Contributor https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor
var role_def_id = resourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
var principal_id = function_app_resource.identity.principalId

module function_app_role_assignment 'function_app_role_assignments.bicep' = {
  name: 'func_app_role_asnmnt_blob_data_cont_${function_app_name}'
  params: {
    role_assignment_name: guid(
      'Storage Blob Data Contributor',
      role_def_id,
      function_app_name,
      function_app_storage_account_name,
      environment_name,
      principal_id
    )
    role_def_id: role_def_id
    principal_id: principal_id
    function_app_storage_account_name: function_app_storage_account_name
  }
}
