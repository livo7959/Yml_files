param environment_name string

resource container_app_acr_managed_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: 'container_app_acr_${environment_name}'
}

// AcrPull role https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#acrpull
var role_def_id = resourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')

resource container_app_acr_pull 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(
    resourceGroup().id,
    container_app_acr_managed_identity.id,
    role_def_id
  )
  properties: {
    roleDefinitionId: role_def_id
    principalId: container_app_acr_managed_identity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}
