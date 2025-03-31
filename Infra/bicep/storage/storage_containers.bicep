param storageAccountName string
param containers array

resource containersLoop 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = [ for containerName in containers : {
  name: '${storageAccountName}/default/${containerName}'
  properties: {
    publicAccess: 'None'
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
  }
}]
