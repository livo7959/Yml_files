module "service_bus_name" {
  source = "../naming"

  for_each = {
    for each in local.service_bus_configs :
    each.service_bus_id => each
  }

  resource_type = "service_bus"
  env           = var.env
  location      = each.value.resource_group.location
  name          = each.value.service_bus_id
}

resource "azurerm_servicebus_namespace" "service_bus_namespace" {
  for_each = {
    for each in local.service_bus_configs :
    each.service_bus_id => each
  }

  name                = module.service_bus_name[each.key].name
  location            = each.value.resource_group.location
  resource_group_name = each.value.resource_group.name
  sku                 = "Standard"
  local_auth_enabled  = false

  network_rule_set {
    default_action                = "Deny"
    public_network_access_enabled = true # Needs to be true to apply IP Rules, otherwise continues to modify config
    trusted_services_allowed      = true

    ip_rules = [
      "66.97.189.250"
    ]
  }

  tags = local.common_tags
}

resource "azurerm_servicebus_queue" "queues" {
  for_each = {
    for each in flatten([
      for service_bus_config in local.service_bus_configs : [
        for queue_config in service_bus_config.service_bus_config.queues : {
          queue_config   = queue_config
          service_bus_id = service_bus_config.service_bus_id
        }
      ]
    ]) : "${each.service_bus_id}-${each.queue_config.name}" => each
  }
  name         = each.value.queue_config.name
  namespace_id = azurerm_servicebus_namespace.service_bus_namespace[each.value.service_bus_id].id

  default_message_ttl   = "P14D"
  partitioning_enabled  = false
  max_delivery_count    = 5
  max_size_in_megabytes = 1024
}

resource "azurerm_servicebus_topic" "topics" {
  for_each = {
    for each in flatten([
      for service_bus_config in local.service_bus_configs : [
        for topic_config in service_bus_config.service_bus_config.topics : {
          topic_config   = topic_config
          service_bus_id = service_bus_config.service_bus_id
        }
      ]
    ]) : "${each.service_bus_id}-${each.topic_config.name}" => each
  }
  name         = each.value.topic_config.name
  namespace_id = azurerm_servicebus_namespace.service_bus_namespace[each.value.service_bus_id].id

  default_message_ttl   = "P1D"
  partitioning_enabled  = false
  max_size_in_megabytes = 1024
}

resource "azurerm_servicebus_subscription" "subscriptions" {
  for_each = {
    for each in flatten([
      for service_bus_config in local.service_bus_configs : [
        for subscription_config in service_bus_config.service_bus_config.subscriptions : {
          subscription_config = subscription_config
          service_bus_id      = service_bus_config.service_bus_id
        }
      ]
    ]) : "${each.service_bus_id}-${each.subscription_config.name}" => each
  }
  name     = each.value.subscription_config.name
  topic_id = azurerm_servicebus_topic.topics["${each.value.service_bus_id}-${each.value.subscription_config.topic_name}"].id

  default_message_ttl = "P1D"
  max_delivery_count  = each.value.subscription_config.max_delivery_count
}
