resource role_assignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('Assignment of "LogixHealth Storage Account Data User ${resourceGroup().name}" role')
  properties: {
    description: 'Assignment of "LogixHealth Storage Account Data User ${resourceGroup().name}" role'
    principalId: '3b0e0055-41f7-4a61-b944-052651aeef1a' // Data_Exchange_Storage_Account_Writers
    principalType: 'Group'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', guid('LogixHealth Storage Account Data User ${resourceGroup().name}'))
  }
}
