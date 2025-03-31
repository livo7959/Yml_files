module "azuread_application" {
  source = "../"

  display_name     = "TF Test Application"
  identifier_uris  = []
  sign_in_audience = "AzureADMyOrg"

  homepage_url  = "https://localhost"
  logout_url    = "https://localhost/logout"
  redirect_uris = ["https://localhost/callback"]

  access_token_issuance_enabled = false
  id_token_issuance_enabled     = true

  mapped_claims_enabled          = true
  requested_access_token_version = 2
  known_client_applications      = []

  optional_claims = {
    id_token = [
      {
        name                  = "upn"
        source                = null
        essential             = false
        additional_properties = []
      },
      {
        name                  = "email"
        source                = null
        essential             = false
        additional_properties = []
      }
    ],
    access_token = [],
    saml2_token  = []

  }

  oauth2_permission_scope = []
  app_roles               = []

  required_resource_accesses = [
    {
      resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph
      resource_access = [
        {
          id   = "14dad69e-099b-42c9-810b-d002981feec1"
          type = "Scope" # Delegated permissions are of type "Scope"
        },
        {
          id   = "64a6cdd6-aab1-4aaf-94b8-3cc8405e90d0"
          type = "Scope" # Delegated permissions are of type "Scope"
        },
        {
          id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
          type = "Scope"
        }
      ]
    }
  ]
}
