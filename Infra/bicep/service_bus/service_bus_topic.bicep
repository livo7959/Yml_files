param sb_topics array
param namespace string
param environment_name string

resource topics 'Microsoft.ServiceBus/namespaces/topics@2022-10-01-preview' = [ for sb_topic in sb_topics: {
  name: '${namespace}/${sb_topic.name}-${environment_name}'
  properties: {
    autoDeleteOnIdle: sb_topic.autoDeleteOnIdle
    defaultMessageTimeToLive: sb_topic.defaultMessageTimeToLive
    duplicateDetectionHistoryTimeWindow: sb_topic.duplicateDetectionHistoryTimeWindow
    enableBatchedOperations: true
    enablePartitioning: false
    enableExpress: false
    maxMessageSizeInKilobytes: 256
    maxSizeInMegabytes: 1024
    requiresDuplicateDetection: true
    supportOrdering: true
  }
}]

module subscriptions './service_bus_subscription.bicep' = [for sb_topic in sb_topics: {
  name: sb_topic.name
  params: {
    namespace: namespace
    topic: '${sb_topic.name}-${environment_name}'
    sb_subscriptions: sb_topic.subscriptions
    environment_name: environment_name
  }
  dependsOn: [
    topics
  ]
}]
