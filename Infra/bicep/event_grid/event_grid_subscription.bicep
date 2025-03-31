param environment_name string
param event_grid_topic_subscriptions array
param storage_account_name string

resource storage_account 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storage_account_name
}

resource eventgridsubscription 'Microsoft.EventGrid/eventSubscriptions@2022-06-15' = [for event_grid_subscription in event_grid_topic_subscriptions: {
  name: '${event_grid_subscription.name}-${environment_name}'
  scope: storage_account
  properties: {
    destination: {
      endpointType: 'ServiceBusTopic'
      properties: {
        resourceId: resourceId('Microsoft.ServiceBus/namespaces/topics', '${event_grid_subscription.destination_topic_namespace}-${environment_name}', '${event_grid_subscription.destination_topic_name}-${environment_name}')
      }
    }
    eventDeliverySchema: 'EventGridSchema'
    retryPolicy: {
      eventTimeToLiveInMinutes: 2
      maxDeliveryAttempts: 10
    }
    filter: {
      includedEventTypes: event_grid_subscription.includedEventTypes
      enableAdvancedFilteringOnArrays: true
    }
  }
}]
