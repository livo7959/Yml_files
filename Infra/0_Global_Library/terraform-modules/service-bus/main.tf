resource "azurerm_servicebus_namespace" "this" {
  name                          = "sbns-${local.base_namespace_name}"
  resource_group_name           = var.resource_group_name
  location                      = module.common_constants.region_short_name_to_long_name[var.location]
  sku                           = var.sku
  capacity                      = var.capacity
  premium_messaging_partitions  = var.premium_messaging_partitions
  local_auth_enabled            = var.local_auth_enabled
  public_network_access_enabled = var.public_network_access_enabled
  minimum_tls_version           = var.minimum_tls_version
  tags                          = local.merged_tags

  dynamic "identity" {
    for_each = var.identity
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
  dynamic "network_rule_set" {
    for_each = var.network_rule_set
    content {
      default_action                = network_rule_set.value.default_action
      public_network_access_enabled = network_rule_set.value.public_network_access_enabled
      trusted_services_allowed      = network_rule_set.value.trusted_services_allowed
      ip_rules                      = network_rule_set.value.ip_rules
      dynamic "network_rules" {
        for_each = network_rule_set.value.network_rules != null ? [network_rule_set.value.network_rules] : []
        content {
          subnet_id                            = network_rules.value.subnet_id
          ignore_missing_vnet_service_endpoint = network_rules.value.ignore_missing_vnet_service_endpoint
        }
      }
    }
  }
}
resource "azurerm_servicebus_queue" "this" {
  for_each                                = var.queues
  name                                    = "sbq-${each.key}"
  namespace_id                            = azurerm_servicebus_namespace.this.id
  lock_duration                           = each.value.lock_duration
  max_message_size_in_kilobytes           = each.value.max_message_size_in_kilobytes
  max_size_in_megabytes                   = each.value.max_size_in_megabytes
  requires_duplicate_detection            = each.value.requires_duplicate_detection
  requires_session                        = each.value.requires_session
  default_message_ttl                     = each.value.default_message_ttl
  dead_lettering_on_message_expiration    = each.value.dead_lettering_on_message_expiration
  duplicate_detection_history_time_window = each.value.duplicate_detection_history_time_window
  max_delivery_count                      = each.value.max_delivery_count
  status                                  = each.value.status
  batched_operations_enabled              = each.value.batched_operations_enabled
  auto_delete_on_idle                     = each.value.auto_delete_on_idle
  partitioning_enabled                    = each.value.partitioning_enabled
  express_enabled                         = each.value.express_enabled
  forward_to                              = each.value.forward_to
  forward_dead_lettered_messages_to       = each.value.forward_dead_lettered_messages_to
}

resource "azurerm_servicebus_topic" "this" {
  for_each                                = var.topics
  name                                    = "sbt-${each.key}"
  namespace_id                            = azurerm_servicebus_namespace.this.id
  status                                  = each.value.status
  auto_delete_on_idle                     = each.value.auto_delete_on_idle
  default_message_ttl                     = each.value.default_message_ttl
  duplicate_detection_history_time_window = each.value.duplicate_detection_history_time_window
  batched_operations_enabled              = each.value.batched_operations_enabled
  express_enabled                         = each.value.express_enabled
  partitioning_enabled                    = each.value.partitioning_enabled
  max_message_size_in_kilobytes           = each.value.max_message_size_in_kilobytes
  max_size_in_megabytes                   = each.value.max_size_in_megabytes
  requires_duplicate_detection            = each.value.requires_duplicate_detection
  support_ordering                        = each.value.support_ordering
}

resource "azurerm_servicebus_subscription" "this" {
  # Transform nested topics/subscriptions into flat map for for_each
  # Creates map that for_each will use & flatten from nested array to single array , then loop through each item in flattened array
  for_each = {
    for sub in flatten([
      # Loop through topics
      for topic_key, topic in var.topics : [
        # Loop through subscriptions in each topic
        for sub_key, sub in topic.subscriptions : {
          topic_key = topic_key                 # Topic name , topic1
          sub_key   = sub_key                   # Subscription name, sub1
          key       = "${topic_key}.${sub_key}" # Unique identifier like topic1.sub1
          config    = sub                       # Subscription settings
        }
      ]
    ]) : sub.key => sub #topic1.sub1 => all sub data
  }

  name                                      = "sbs-${each.value.sub_key}"
  topic_id                                  = azurerm_servicebus_topic.this[each.value.topic_key].id
  max_delivery_count                        = each.value.config.max_delivery_count
  auto_delete_on_idle                       = each.value.config.auto_delete_on_idle
  default_message_ttl                       = each.value.config.default_message_ttl
  lock_duration                             = each.value.config.lock_duration
  dead_lettering_on_message_expiration      = each.value.config.dead_lettering_on_message_expiration
  dead_lettering_on_filter_evaluation_error = each.value.config.dead_lettering_on_filter_evaluation_error
  batched_operations_enabled                = each.value.config.batched_operations_enabled
  requires_session                          = each.value.config.requires_session
  forward_to                                = each.value.config.forward_to
  forward_dead_lettered_messages_to         = each.value.config.forward_dead_lettered_messages_to
  status                                    = each.value.config.status
  client_scoped_subscription_enabled        = each.value.config.client_scoped_subscription_enabled

  dynamic "client_scoped_subscription" {
    for_each = each.value.config.client_scoped_subscription[*]
    content {
      client_id                               = client_scoped_subscription.value.client_id
      is_client_scoped_subscription_shareable = client_scoped_subscription.value.is_client_scoped_subscription_shareable
    }
  }
}

