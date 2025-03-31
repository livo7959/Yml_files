param local_users array
param storage_account_name string
param environment_name string

// Reference to the parent resource
resource storage_account_resource 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storage_account_name
}

resource storage_account_local_users 'Microsoft.Storage/storageAccounts/localUsers@2022-09-01' =[for local_user in local_users: {
  parent: storage_account_resource
  name: local_user.name
  properties: {
    hasSharedKey: false
    hasSshKey: true
    hasSshPassword: true
    homeDirectory: local_user.homeDirectory
    permissionScopes: [ for resource_name in local_user.resourceName: {
      permissions: local_user.permissions
      resourceName: '${resource_name}-${environment_name}'
      service: local_user.service
    }]
  }
}]
