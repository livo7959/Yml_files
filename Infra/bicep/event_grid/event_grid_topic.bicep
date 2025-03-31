param environment_name string
param event_grid_topic_subscriptions array
param storage_account_name string
param location string

resource event_grid_topic 'Microsoft.EventGrid/systemTopics@2022-06-15' = [for event_grid_topic in event_grid_topic_subscriptions: {
  name: '${event_grid_topic.name}-${environment_name}'
  location: location
  tags: {
    environment: environment_name
  }
  properties: {
    source: resourceId('Microsoft.Storage/storageAccounts', storage_account_name)
    topicType: 'Microsoft.Storage.StorageAccounts'
  }
}]
