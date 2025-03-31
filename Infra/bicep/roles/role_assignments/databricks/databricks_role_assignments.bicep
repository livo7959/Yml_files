param environment_name string

param databricks_workspace_name string
param databricks_managed_identity_principal_id string
param databricks_access_connector_principal_id string

param key_vault_name string
param key_vault_role_definition_id string

param storage_account_name string
param storage_role_definition_id string

resource databricks_key_vault_resources 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: key_vault_name
}

resource key_vault_role_assignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(
    'Key Vault Secrets User',
    key_vault_role_definition_id,
    databricks_managed_identity_principal_id,
    key_vault_name,
    environment_name
  )
  scope: databricks_key_vault_resources
  properties: {
    roleDefinitionId: key_vault_role_definition_id
    principalId: databricks_managed_identity_principal_id
    principalType: 'ServicePrincipal'
  }
}

resource storage_account 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storage_account_name
}

resource storage_role_assignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(
    'Storage Blob Data Contributor',
    storage_role_definition_id,
    databricks_workspace_name,
    storage_account_name,
    environment_name
  )
  scope: storage_account
  properties: {
    roleDefinitionId: storage_role_definition_id
    principalId: databricks_access_connector_principal_id
    principalType: 'ServicePrincipal'
  }
}
