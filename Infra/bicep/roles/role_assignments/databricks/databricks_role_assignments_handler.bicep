param location_shortname string
param environment_name string

param key_vault_name string
param databricks_managed_resource_group_name string
param databricks_workspace_name string

resource databricks_managed_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: 'dbmanagedidentity'
  scope: resourceGroup(databricks_managed_resource_group_name)
}

resource databricks_access_connector 'Microsoft.Databricks/accessConnectors@2022-10-01-preview' existing = {
  name: databricks_workspace_name
}

module databricks_role_assignments 'databricks_role_assignments.bicep' = {
  name: 'role_assignments'
  params: {
    environment_name: environment_name
    databricks_workspace_name: databricks_workspace_name
    databricks_managed_identity_principal_id: databricks_managed_identity.properties.principalId
    databricks_access_connector_principal_id: databricks_access_connector.identity.principalId
    key_vault_name: key_vault_name
    // Key Vault Secrets User https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-guide?tabs=azure-cli#azure-built-in-roles-for-key-vault-data-plane-operations
    key_vault_role_definition_id: resourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')
    storage_account_name: environment_name == 'shared' ? 'unitycatalog${location_shortname}shared' : 'lhdatalakestorage${environment_name}'
    // Storage Blob Data Contributor https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor
    storage_role_definition_id: resourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
  }
}
