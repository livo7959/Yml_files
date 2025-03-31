locals {
  container_app_managed_environment_basename = "lh-container-app"
  container_app_acr_identity_basename        = "container_app_acr"
  custom_domains = flatten([
    for container_app_config in local.container_app_configs : [
      for custom_domain in container_app_config.container_app_config.domains : {
        custom_domain_name = custom_domain.name
        container_app_name = container_app_config.container_app_config.name
        rg_name            = container_app_config.rg_basename
      }
    ]
  ])
}

module "container_app_managed_environment_name" {
  source = "../naming"
  for_each = {
    for rg_name, rg_config in var.resource_groups :
    rg_name => rg_config
    if length(rg_config.resources.container_apps) > 0
  }

  resource_type = "container_app_managed_environment"
  env           = var.env
  location      = each.value.location
  name          = local.container_app_managed_environment_basename
}

resource "azurerm_container_app_environment" "container_app_environment" {
  for_each = {
    for rg_name, rg_config in var.resource_groups :
    rg_name => rg_config
    if length(rg_config.resources.container_apps) > 0
  }
  name                = module.container_app_managed_environment_name[each.key].name
  location            = each.value.location
  resource_group_name = azurerm_resource_group.resource_groups[each.key].name

  tags = local.common_tags
}

module "container_app_name" {
  source = "../naming"

  for_each = {
    for idx, container_app_config in local.container_app_configs :
    container_app_config.container_app_config.name => container_app_config
  }

  resource_type = "container_app"
  env           = var.env
  location      = azurerm_resource_group.resource_groups[each.value.rg_basename].location
  name          = each.key
}

resource "azurerm_user_assigned_identity" "container_app_acr" {
  for_each = {
    for idx, container_app_config in local.container_app_configs :
    container_app_config.container_app_config.name => container_app_config
  }

  location            = azurerm_resource_group.resource_groups[each.value.rg_basename].location
  name                = "${local.container_app_acr_identity_basename}-${module.container_app_name[each.key].name}"
  resource_group_name = azurerm_resource_group.resource_groups[each.value.rg_basename].name

  tags = local.common_tags
}

resource "azurerm_role_assignment" "acr_pull" {
  for_each = {
    for idx, container_app_config in local.container_app_configs :
    container_app_config.container_app_config.name => container_app_config
  }

  scope                = azurerm_container_registry.acr[each.value.container_app_config.registry_name].id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.container_app_acr[each.key].principal_id
}

# Using azapi provider due to known limitations with azurerm_container_app resources https://github.com/hashicorp/terraform-provider-azurerm/issues/21866
# further, cannot restrict network access with ipSecurityRestrictions with azurerm_container_app resources
resource "azapi_resource" "container_apps" {
  for_each = {
    for idx, container_app_config in local.container_app_configs :
    container_app_config.container_app_config.name => container_app_config
  }
  type      = "Microsoft.App/containerApps@2023-05-01"
  name      = module.container_app_name[each.key].name
  location  = azurerm_resource_group.resource_groups[each.value.rg_basename].location
  parent_id = azurerm_resource_group.resource_groups[each.value.rg_basename].id
  tags      = local.common_tags
  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.container_app_acr[each.key].id
    ]
  }
  body = jsonencode({
    properties = {
      configuration = {
        activeRevisionsMode = "Single"
        ingress = {
          allowInsecure         = false
          clientCertificateMode = "Ignore"
          external              = true
          ipSecurityRestrictions = [
            {
              action         = "Allow"
              name           = "LogixInternal"
              ipAddressRange = "66.97.189.250"
            }
          ]
          targetPort = each.value.container_app_config.target_port
          traffic = [
            {
              latestRevision = true
              weight         = 100
            }
          ]
          transport = "Auto"
        }
        registries = [
          {
            identity = azurerm_user_assigned_identity.container_app_acr[each.key].id
            server   = azurerm_container_registry.acr[each.value.container_app_config.registry_name].login_server
          }
        ]
      }
      environmentId = azurerm_container_app_environment.container_app_environment[each.value.rg_basename].id
      template = {
        containers = [for container in each.value.container_app_config.containers :
          {
            image = "${azurerm_container_registry.acr[each.value.container_app_config.registry_name].login_server}/${container.image_name}:latest"
            name  = container.container_name
            resources = {
              cpu    = container.cpu_core
              memory = container.memory_size
            }
          }
        ]
        scale = {
          maxReplicas = 3
          minReplicas = 1
        }
      }
    }
  })
}
