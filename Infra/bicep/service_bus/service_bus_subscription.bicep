param sb_subscriptions array
param topic string
param environment_name string
param namespace string

resource symbolicname 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2022-10-01-preview' = [for sb_subscription in sb_subscriptions: {
  name: '${namespace}/${topic}/${sb_subscription.name}-${environment_name}'
  properties: {
    autoDeleteOnIdle: sb_subscription.autoDeleteOnIdle
    deadLetteringOnFilterEvaluationExceptions: true
    deadLetteringOnMessageExpiration: true
    defaultMessageTimeToLive: sb_subscription.defaultMessageTimeToLive
    duplicateDetectionHistoryTimeWindow: sb_subscription.?duplicateDetectionHistoryTimeWindow ?? ''
    enableBatchedOperations: true
    isClientAffine: false
    lockDuration: sb_subscription.lockDuration
    maxDeliveryCount: sb_subscription.maxDeliveryCount
    requiresSession: true
  }
}]
