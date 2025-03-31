module "container_registry_name" {
  source = "../naming"

  for_each = {
    for idx, container_registry_config in local.container_registry_configs :
    container_registry_config.container_registry_config.name => container_registry_config
  }

  resource_type = "container_registry"
  env           = var.env
  location      = each.value.resource_group.location
  name          = each.key
}

resource "azurerm_container_registry" "acr" {
  for_each = {
    for idx, container_registry_config in local.container_registry_configs :
    container_registry_config.container_registry_config.name => container_registry_config
  }

  name                          = module.container_registry_name[each.value.container_registry_config.name].name
  resource_group_name           = each.value.resource_group.name
  location                      = each.value.resource_group.location
  sku                           = each.value.container_registry_config.sku
  admin_enabled                 = true
  public_network_access_enabled = true
  zone_redundancy_enabled       = false
  quarantine_policy_enabled     = false
  export_policy_enabled         = true
  anonymous_pull_enabled        = false
  trust_policy_enabled          = false
  network_rule_bypass_option    = "AzureServices"
  retention_policy_in_days      = 14

  network_rule_set {
    default_action = "Deny"
    ip_rule = [
      {
        action   = "Allow"
        ip_range = "66.97.189.250/32"
      }
    ]
  }

  tags = local.common_tags
}
