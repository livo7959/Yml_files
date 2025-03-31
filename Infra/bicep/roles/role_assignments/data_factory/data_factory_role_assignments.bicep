param role_assignment_name string
param role_def_id string
param principal_id string

param data_factory_storage_account_name string
param data_factory_storage_service_name string
param data_factory_storage_container_name string

resource data_factory_storage_account 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: data_factory_storage_account_name
}

resource data_factory_storage_service 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' existing = {
  parent: data_factory_storage_account
  name: data_factory_storage_service_name
}

resource data_factory_storage_container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' existing = if (data_factory_storage_container_name != '') {
  parent: data_factory_storage_service
  name: data_factory_storage_container_name
}

resource data_factory_storage_contributor_role_assignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: role_assignment_name
  scope: data_factory_storage_container_name != '' ? data_factory_storage_container : data_factory_storage_account
  properties: {
    roleDefinitionId: role_def_id
    principalId: principal_id
    principalType: 'ServicePrincipal'
  }
}
