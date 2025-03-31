variable "display_name" {
  description = "The display name for the Azure AD application"
  type        = string
  default     = ""
}

variable "identifier_uris" {
  description = "The identifier URIs for the Azure AD application"
  type        = list(string)
  default     = []
}

variable "logo_image" {
  description = "The path to the logo image for the Azure AD application"
  type        = string
  default     = ""
}

variable "sign_in_audience" {
  description = "The sign-in audience for the Azure AD application"
  type        = string
  default     = "AzureADMyOrg"
}

variable "homepage_url" {
  description = "The homepage URL for the Azure AD application"
  type        = string
  default     = "https://app.example.net"
}

variable "logout_url" {
  description = "The logout URL for the Azure AD application"
  type        = string
  default     = "https://app.example.net/logout"
}

variable "redirect_uris" {
  description = "The redirect URIs for the Azure AD application"
  type        = list(string)
  default     = ["https://app.example.net/account"]
}

variable "access_token_issuance_enabled" {
  description = "Enable the issuance of access tokens. Used for implicit flows"
  type        = bool
  default     = false
}

variable "id_token_issuance_enabled" {
  description = "Enable the issuance of ID tokens. Used for implicit and hybrid flows, enable true for .net web apps."
  type        = bool
  default     = false
}

variable "mapped_claims_enabled" {
  description = "Enable mapped claims"
  type        = bool
  default     = true
}

variable "requested_access_token_version" {
  description = "Requested access token version"
  type        = number
  default     = 2
}

variable "known_client_applications" {
  description = "List of known client applications"
  type        = list(string)
  default     = []
}

variable "optional_claims" {
  description = "The optional claims for the Azure AD application"
  type = object({
    access_token = list(object({
      name = string
    }))
    id_token = list(object({
      name                  = string
      source                = string
      essential             = bool
      additional_properties = list(string)
    }))
    saml2_token = list(object({
      name = string
    }))
  })
  default = {
    access_token = []
    id_token     = []
    saml2_token  = []
  }
}

variable "oauth2_permission_scope" {
  description = "The OAuth2 permission scope for the Azure AD application. Entra ID > App Reg > Expose an API."
  type = list(object({
    admin_consent_description  = string
    admin_consent_display_name = string
    enabled                    = bool
    id                         = string
    type                       = string
    user_consent_description   = string
    user_consent_display_name  = string
    value                      = string
  }))
  default = []
}

variable "app_roles" {
  description = "List of app roles. In Entra ID > App Registration > App Roles."
  type = list(object({
    allowed_member_types = list(string)
    description          = string
    display_name         = string
    enabled              = bool
    id                   = string
    value                = string
  }))
  default = []
}

variable "required_resource_accesses" {
  description = "List of required resource access. These are API permissions in Entra ID > App Registration > API permissions."
  type = list(object({
    resource_app_id = string
    resource_access = list(object({
      id   = string
      type = string
    }))
  }))
  default = []
}
