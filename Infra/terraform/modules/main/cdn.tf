module "cdn_profile_name" {
  source = "../naming"

  for_each = {
    for idx, each in local.cdn_configs :
    each.cdn_profile_config.name => each
  }

  resource_type = "cdn_profile"
  env           = var.env
  location      = each.value.resource_group.location
  name          = each.value.cdn_profile_config.name
}

resource "azurerm_cdn_profile" "cdn_profiles" {
  for_each = {
    for idx, each in local.cdn_configs :
    each.cdn_profile_config.name => each
  }

  name                = module.cdn_profile_name[each.key].name
  location            = each.value.resource_group.location
  resource_group_name = each.value.resource_group.name
  sku                 = "Standard_Microsoft"

  tags = local.common_tags
}


resource "azurerm_cdn_endpoint" "cdn_endpoints" {
  for_each = {
    for each in flatten([
      for cdn_config in local.cdn_configs : [
        for endpoint_config in cdn_config.cdn_profile_config.endpoint_configs : {
          cdn_profile_name = cdn_config.cdn_profile_config.name
          endpoint_config  = endpoint_config
          location         = cdn_config.resource_group.location
          rg_name          = cdn_config.resource_group.name
        }
      ]
    ]) : "${each.cdn_profile_name}-${each.endpoint_config.name}" => each
  }

  name                = "${each.value.endpoint_config.name}-${var.env}"
  profile_name        = azurerm_cdn_profile.cdn_profiles[each.value.cdn_profile_name].name
  location            = each.value.location
  resource_group_name = each.value.rg_name

  is_http_allowed    = false
  origin_path        = each.value.endpoint_config.origin_path
  origin_host_header = each.value.endpoint_config.host_name

  origin {
    name      = each.value.endpoint_config.origin_name
    host_name = each.value.endpoint_config.host_name
  }
}

resource "azurerm_cdn_endpoint_custom_domain" "cdn_custom_domains" {
  for_each = {
    for each in flatten([
      for cdn_config in local.cdn_configs : [
        for endpoint_config in cdn_config.cdn_profile_config.endpoint_configs : {
          cdn_profile_name = cdn_config.cdn_profile_config.name
          endpoint_config  = endpoint_config
          location         = cdn_config.resource_group.location
          rg_name          = cdn_config.resource_group.name
        }
      ]
    ]) : "${each.cdn_profile_name}-${each.endpoint_config.name}" => each
    if each.endpoint_config.custom_domain != null
  }

  name            = each.key
  cdn_endpoint_id = azurerm_cdn_endpoint.cdn_endpoints[each.key].id
  host_name       = each.value.endpoint_config.custom_domain

  cdn_managed_https {
    certificate_type = "Dedicated"
    protocol_type    = "ServerNameIndication"
  }
}
