data "azuread_client_config" "current" {}

resource "random_uuid" "app_scope_id" {
  for_each = { for app in var.applications : app.display_name => app if app.random_uuid_required }
}

resource "azuread_application" "this" {
  for_each = { for app in var.applications : app.display_name => app }

  display_name     = each.value.display_name
  identifier_uris  = try(each.value.identifier_uris, [])
  owners           = [data.azuread_client_config.current.object_id]
  sign_in_audience = each.value.sign_in_audience
  tags             = each.value.tags

  web {
    homepage_url  = each.value.homepage_url
    logout_url    = each.value.logout_url
    redirect_uris = each.value.redirect_uris

    implicit_grant {
      access_token_issuance_enabled = each.value.access_token_issuance_enabled
      id_token_issuance_enabled     = each.value.id_token_issuance_enabled
    }
  }

  api {
    mapped_claims_enabled          = each.value.mapped_claims_enabled
    requested_access_token_version = each.value.requested_access_token_version

    known_client_applications = each.value.known_client_applications

    dynamic "oauth2_permission_scope" {
      for_each = each.value.oauth2_permission_scope
      content {
        admin_consent_description  = oauth2_permission_scope.value.admin_consent_description
        admin_consent_display_name = oauth2_permission_scope.value.admin_consent_display_name
        enabled                    = oauth2_permission_scope.value.enabled
        id                         = random_uuid.app_scope_id[each.key].result
        type                       = oauth2_permission_scope.value.type
        user_consent_description   = oauth2_permission_scope.value.user_consent_description
        user_consent_display_name  = oauth2_permission_scope.value.user_consent_display_name
        value                      = oauth2_permission_scope.value.value
      }
    }
  }

  single_page_application {
    redirect_uris = each.value.single_page_app_redirect_uris
  }

  optional_claims {
    dynamic "access_token" {
      for_each = each.value.optional_claims.access_token
      content {
        name                  = access_token.value.name
        source                = access_token.value.source
        essential             = access_token.value.essential
        additional_properties = access_token.value.additional_properties
      }
    }

    dynamic "id_token" {
      for_each = each.value.optional_claims.id_token
      content {
        name                  = id_token.value.name
        source                = id_token.value.source
        essential             = id_token.value.essential
        additional_properties = id_token.value.additional_properties
      }
    }

    dynamic "saml2_token" {
      for_each = each.value.optional_claims.saml2_token
      content {
        name                  = saml2_token.value.name
        source                = saml2_token.value.source
        essential             = saml2_token.value.essential
        additional_properties = saml2_token.value.additional_properties
      }
    }
  }

  dynamic "app_role" {
    for_each = each.value.app_roles
    content {
      allowed_member_types = app_role.value.allowed_member_types
      description          = app_role.value.description
      display_name         = app_role.value.display_name
      enabled              = app_role.value.enabled
      id                   = app_role.value.id
      value                = app_role.value.value
    }
  }

  dynamic "required_resource_access" {
    for_each = each.value.required_resource_accesses
    content {
      resource_app_id = required_resource_access.value.resource_app_id

      dynamic "resource_access" {
        for_each = required_resource_access.value.resource_access
        content {
          id   = resource_access.value.id
          type = resource_access.value.type
        }
      }
    }
  }
}

resource "azuread_service_principal" "this" {
  for_each = { for app in var.applications : app.display_name => app }

  client_id                    = azuread_application.this[each.key].client_id
  owners                       = [data.azuread_client_config.current.object_id]
  app_role_assignment_required = each.value.app_role_assignment_required
}
