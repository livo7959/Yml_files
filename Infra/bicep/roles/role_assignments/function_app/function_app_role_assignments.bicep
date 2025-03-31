param role_assignment_name string
param role_def_id string
param function_app_storage_account_name string
param principal_id string

resource function_app_storage_account 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: function_app_storage_account_name
}

resource function_app_storage_contributor_role_assignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: role_assignment_name
  scope: function_app_storage_account
  properties: {
    roleDefinitionId: role_def_id
    principalId: principal_id
    principalType: 'ServicePrincipal'
  }
}
