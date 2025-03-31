applications = [
  {
    display_name                   = "Application1"
    identifier_uris                = ["https://example.com/app1"]
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://example.com/app1"
    logout_url                     = "https://example.com/app1/logout"
    redirect_uris                  = ["https://example.com/app1/callback"]
    access_token_issuance_enabled  = true
    id_token_issuance_enabled      = true
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
    app_roles                    = []
    required_resource_accesses   = []
    app_role_assignment_required = false
  },
  {
    display_name                   = "Application2"
    identifier_uris                = ["https://example.com/app2"]
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://example.com/app2"
    logout_url                     = "https://example.com/app2/logout"
    redirect_uris                  = ["https://example.com/app2/callback"]
    access_token_issuance_enabled  = true
    id_token_issuance_enabled      = true
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
    app_roles                    = []
    required_resource_accesses   = []
    app_role_assignment_required = false
  },
  {
    display_name                   = "SPATest-DEV"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://spatestdev.logixhealth.com"
    logout_url                     = "https://spatestdev.logixhealth.com/"
    redirect_uris                  = []
    single_page_app_redirect_uris  = ["https://spatestdev.logixhealth.com/"]
    tags                           = ["HideApp", "WindowsAzureActiveDirectoryIntegratedApp"]
    access_token_issuance_enabled  = false
    id_token_issuance_enabled      = false
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
        },
        {
          name                  = "sid"
          source                = null
          essential             = false
          additional_properties = []
        }
      ],
      access_token = [],
      saml2_token  = []
    }
    app_roles = []
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
            type = "Scope"
          },
          {
            id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
            type = "Scope"
          }
        ]
      }
    ]
    oauth2_permission_scope = [
      {
        admin_consent_description  = "Permission to read basic user profile"
        admin_consent_display_name = "User.Read"
        user_consent_description   = "Permission to read basic user profile"
        user_consent_displayname   = "User.Read"
        type                       = "User"
        value                      = "User.Read"
      }
    ]
    app_role_assignment_required = false
    random_uuid_required         = true
  }
]
