param description string
param principal_id string
param principal_type string
param role_definition_id string

resource role_assignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(description)
  properties: {
    description: description
    principalId: principal_id
    principalType: principal_type
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role_definition_id)
  }
}
