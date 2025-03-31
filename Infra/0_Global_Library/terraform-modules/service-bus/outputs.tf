output "servicebus_namespace_id" {
  value       = azurerm_servicebus_namespace.this.id
  description = "ID of ServiceBus namespace"
}
output "servicebus_queue_ids" {
  value       = { for k, v in azurerm_servicebus_queue.this : k => v.id }
  description = "ID of ServiceBus queues"
}
output "servicebus_topic_ids" {
  value       = { for k, v in azurerm_servicebus_topic.this : k => v.id }
  description = "ID of ServiceBus topics"
}
output "servicebus_subscription_ids" {
  value       = { for k, v in azurerm_servicebus_subscription.this : k => v.id }
  description = "ID of ServiceBus subscriptions"

}
