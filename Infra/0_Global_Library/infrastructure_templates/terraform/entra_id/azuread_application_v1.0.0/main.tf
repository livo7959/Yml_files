data "azuread_client_config" "current" {}

resource "azuread_application" "example" {

  display_name     = var.display_name
  identifier_uris  = var.identifier_uris
  owners           = [data.azuread_client_config.current.object_id]
  sign_in_audience = var.sign_in_audience

  web {
    homepage_url  = var.homepage_url
    logout_url    = var.logout_url
    redirect_uris = var.redirect_uris

    implicit_grant {
      access_token_issuance_enabled = var.access_token_issuance_enabled
      id_token_issuance_enabled     = var.id_token_issuance_enabled
    }
  }

  api {
    mapped_claims_enabled          = var.mapped_claims_enabled
    requested_access_token_version = var.requested_access_token_version

    known_client_applications = var.known_client_applications
  }

  optional_claims {
    dynamic "access_token" {
      for_each = var.optional_claims.access_token
      content {
        name                  = access_token.value.name
        source                = access_token.value.source
        essential             = access_token.value.essential
        additional_properties = access_token.value.additional_properties
      }
    }

    dynamic "id_token" {
      for_each = var.optional_claims.id_token
      content {
        name                  = id_token.value.name
        source                = id_token.value.source
        essential             = id_token.value.essential
        additional_properties = id_token.value.additional_properties
      }
    }

    dynamic "saml2_token" {
      for_each = var.optional_claims.saml2_token
      content {
        name                  = saml2_token.value.name
        source                = saml2_token.value.source
        essential             = saml2_token.value.essential
        additional_properties = saml2_token.value.additional_properties
      }
    }
  }

  dynamic "app_role" {
    for_each = var.app_roles
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
    for_each = var.required_resource_accesses
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

resource "azuread_service_principal" "example" {
  client_id                    = azuread_application.example.client_id
  app_role_assignment_required = false
}
