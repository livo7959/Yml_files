variable "applications" {
  description = "List of applications"
  type = list(object({
    display_name                   = string
    identifier_uris                = optional(list(string), null)
    sign_in_audience               = string
    homepage_url                   = string
    logout_url                     = string
    redirect_uris                  = list(string)
    access_token_issuance_enabled  = bool
    id_token_issuance_enabled      = bool
    mapped_claims_enabled          = bool
    requested_access_token_version = number
    known_client_applications      = list(string)
    tags                           = set(string)
    oauth2_permission_scope = list(object({
      admin_consent_description  = optional(string)
      admin_consent_display_name = optional(string)
      enabled                    = optional(bool, true)
      id                         = optional(string)
      type                       = optional(string)
      user_consent_description   = optional(string)
      user_consent_display_name  = optional(string)
      value                      = optional(string)
    }))
    optional_claims = map(list(object({
      name                  = string
      source                = string
      essential             = bool
      additional_properties = list(string)
    })))
    app_roles = list(object({
      allowed_member_types = list(string)
      description          = string
      display_name         = string
      enabled              = bool
      id                   = string
      value                = string
    }))
    required_resource_accesses = list(object({
      resource_app_id = string
      resource_access = list(object({
        id   = string
        type = string
      }))
    }))
    app_role_assignment_required  = bool
    single_page_app_redirect_uris = optional(list(string))
    random_uuid_required          = optional(bool, false)
  }))
}
