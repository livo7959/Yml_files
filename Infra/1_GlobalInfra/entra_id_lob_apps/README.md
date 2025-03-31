# Azure AD Application Terraform Module

This Terraform module provisions Azure AD Applications used by our internal line of business applications.

## Variables

- `applications`: A list of applications to be created. Each application is an object with the following attributes:
  - `display_name`: The display name for the application.
  - `identifier_uris`: A list of unique URIs for the application. Used by Single Page Applications.
  - `sign_in_audience`: The sign-in audience for the application.
  - `homepage_url`: The home page URL for the application.
  - `logout_url`: The logout URL for the application.
  - `redirect_uris`: A list of redirect URIs for the application.
  - `access_token_issuance_enabled`: Enable the issuance of access tokens. Used for implicit flows.
  - `id_token_issuance_enabled`: Enable the issuance of ID tokens. Used for implicit and hybrid flows, enable true for .net web apps.
  - `mapped_claims_enabled`: A boolean indicating whether mapped claims are enabled.
  - `requested_access_token_version`: The requested version for access tokens. Recommended to use version 2.
  - `known_client_applications`: A list of known client applications.
  - `tags`: Unlike, Entra ID tags these are to set properties of the application. Such as: "HideApp", "WindowsAzureActiveDirectoryIntegratedApp".
  - `oauth2_permission_scope`: A list of OAuth2 permission scopes. Used by Single Page Applications.
  - `optional_claims`: A map of optional claims.
  - `app_roles`: A list of application roles.
  - `required_resource_accesses`: A list of required resource accesses.
  - `app_role_assignment_required`: A boolean indicating whether app role assignment is required.
  - `single_page_app_redirect_uris`: A list of single page app redirect URIs (optional).
  - `random_uuid_required`: A boolean indicating whether a random UUID is required (optional, default: false). This is required for Single Page Applications.

## Usage

`.NET Application`

```
applications = [
  {
    display_name                   = "AppName-ENV" (DEV,QA,UAT (no tag for prod as could be user visible.))
    identifier_uris                = []
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://app.logixhealth.com"
    logout_url                     = "https://app.logixhealth.com/"
    redirect_uris                  = ["https://app.logixhealth.com/", "https://app.logixhealth.com/signin-oidc"]
    tags                           = ["HideApp", "WindowsAzureActiveDirectoryIntegratedApp"]
    access_token_issuance_enabled  = false
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
    oauth2_permission_scope      = []
    app_role_assignment_required = false
  },

```

`Single Page Web Application`

```
applications = [
{
    display_name                   = "AppName-ENV" (DEV,QA,UAT (no tag for prod as could be user visible.))
    identifier_uris                = ["api://appid"]
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://app.logixhealth.com"
    logout_url                     = "https://app.logixhealth.com/"
    redirect_uris                  = []
    single_page_app_redirect_uris  = ["https://app.logixhealth.com/"]
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
  },
  {
    app2...
  }
```
