resource storage_account_data_user_role 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid('LogixHealth Storage Account Data User ${resourceGroup().name}')
  properties: {
    assignableScopes: [
      resourceGroup().id
    ]
    description: 'Role to allow data creation / deletion / movement in Storage Account Containers'
    permissions: [
      {
        actions: [
          'Microsoft.Storage/storageAccounts/listKeys/action'
        ]
        dataActions: [
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete'
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write'
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/move/action'
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action'
        ]
        notActions: []
        notDataActions: []
      }
    ]
    roleName: 'LogixHealth Storage Account Data User ${resourceGroup().name}'
    type: 'CustomRole'
  }
}
