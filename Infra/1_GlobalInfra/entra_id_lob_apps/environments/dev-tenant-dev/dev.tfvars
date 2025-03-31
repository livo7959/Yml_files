applications = [
  {
    display_name     = "LogixDenials-DEV"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://ddenials.logixhealth.com"
    logout_url       = "https://ddenials.logixhealth.com/"
    redirect_uris = [
      "https://ddenials.logixhealth.com/",
      "https://ddenials.logixhealth.com/signin-oidc",
      "https://demo-apps.logixhealth.com/LogixDenials/",
      "https://localhost/LogixDenials/",
      "https://localhost/LogixDenials/signin-oidc"
    ]
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
  {
    display_name                   = "LogixPaidRight-DEV"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://dlogixpaidright.logixhealth.com/application"
    logout_url                     = "https://dlogixpaidright.logixhealth.com/application/"
    redirect_uris                  = ["https://dlogixpaidright.logixhealth.com/application/"]
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
  {
    display_name                   = "LogixEnrollment-DEV"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://denrollment.logixhealth.com"
    logout_url                     = "https://denrollment.logixhealth.com/"
    redirect_uris                  = ["https://denrollment.logixhealth.com/", "https://denrollment.logixhealth.com/LogixEnrollment/", "https://denrollment.logixhealth.com/signin-oidc"]
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
  {
    display_name                   = "LogixLockboxDocs-DEV"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://dlockboxdocs.logixhealth.com"
    logout_url                     = "https://dlockboxdocs.logixhealth.com/"
    redirect_uris                  = []
    identifier_uris                = ["api://4783fd4a-99ed-48c8-a598-34c2ecd03592"]
    single_page_app_redirect_uris  = ["https://dlockboxdocs.logixhealth.com/"]
    tags                           = ["HideApp", "WindowsAzureActiveDirectoryIntegratedApp"]
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
    display_name                   = "LogixClaimStatus-DEV"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://dclaimstatus.logixhealth.com"
    logout_url                     = "https://dclaimstatus.logixhealth.com/"
    redirect_uris                  = ["https://dclaimstatus.logixhealth.com/", "https://dclaimstatus.logixhealth.com/signin-oidc"]
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
  {
    display_name     = "LogixEligibility-DEV"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://deligibility.logixhealth.com"
    logout_url       = "https://deligibility.logixhealth.com/"
    redirect_uris = [
      "https://deligibility.logixhealth.com/",
      "https://deligibility.logixhealth.com/signin-oidc",
      "https://localhost:44323/",
      "https://localhost:44323/signin-oidc"
    ]
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
  {
    display_name                   = "LogixProjection-DEV"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://dlogixra.logixhealth.com"
    logout_url                     = "https://dlogixra.logixhealth.com/"
    redirect_uris                  = ["https://dlogixra.logixhealth.com/", "https://dlogixra.logixhealth.com/signin-oidc"]
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
  {
    display_name                   = "LogixLearning-DEV"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://dlearning.logixhealth.com"
    logout_url                     = "https://dlearning.logixhealth.com/learning/"
    redirect_uris                  = ["https://dlearning.logixhealth.com/learning/", "https://dlearning.logixhealth.com/training/"]
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
  {
    display_name                   = "LogixPM-DEV"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://dlogixpm.logixhealth.com"
    logout_url                     = "https://dlogixpm.logixhealth.com/"
    redirect_uris                  = ["https://dlogixpm.logixhealth.com/", "https://dlogixpm.logixhealth.com/signin-oidc"]
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
  {
    display_name                   = "LogixStaffing-DEV"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://devstaffing.logixhealth.com/LogixStaffing"
    logout_url                     = "https://devstaffing.logixhealth.com/LogixStaffing/"
    redirect_uris                  = ["https://devstaffing.logixhealth.com/LogixStaffing/"]
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
  {
    display_name                   = "LogixStaffing2-DEV"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://dev2staffing.logixhealth.com/LogixStaffing"
    logout_url                     = "https://dev2staffing.logixhealth.com/LogixStaffing/"
    redirect_uris                  = ["https://dev2staffing.logixhealth.com/LogixStaffing/"]
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
  {
    display_name     = "LogixConnect-DEV"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://devlhconnect.logixhealth.com/ConnectPortal"
    logout_url       = "https://devlhconnect.logixhealth.com/ConnectPortal/"
    redirect_uris = [
      "https://devlhconnect.logixhealth.com/ConnectPortal/",
      "https://devlhconnect.logixhealth.com/help/",
      "https://devlhconnect.logixhealth.com/ConnectPortal/signin-oidc",
      "https://d1connect.logixhealth.com/ConnectPortal",
      "https://demo-apps.logixhealth.com/ConnectPortal/signin-oidc",
      "https://legacy-apps.logixhealth.com/ConnectPortal/signin-oidc",
      "https://legacyapp.logixhealth.com/ConnectPortal/",
      "https://legacyapp.logixhealth.com/ConnectPortal/signin-oidc",
      "https://localhost:44309/ConnectPortal/",
      "https://myconnectapp.logixhealth.com/ConnectPortal/",
      "https://localhost:50078/",
      "http://localhost:50078/"
    ]
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
  {
    display_name     = "LogixReporting-DEV"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://dreporting.logixhealth.com/"
    logout_url       = "https://dreporting.logixhealth.com/"
    redirect_uris = [
      "https://dreporting.logixhealth.com/",
      "https://dreporting.logixhealth.com/signin-oidc",
      "https://demo-apps.logixhealth.com/LogixReporting",
      "https://localhost:7102/",
      "https://myreporting.logixhealth.com/LogixReporting/"
    ]
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
  {
    display_name                   = "Settings-Reporting-DEV"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://settings.dreporting.logixhealth.com"
    logout_url                     = "https://settings.dreporting.logixhealth.com/"
    redirect_uris                  = ["https://settings.dreporting.logixhealth.com/"]
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
  {
    display_name                   = "LogixFeedback-DEV"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://dfeedback.logixhealth.com/Feedback"
    logout_url                     = "https://dfeedback.logixhealth.com/Feedback/"
    redirect_uris                  = ["https://dfeedback.logixhealth.com/Feedback/", "https://localhost:44300/"]
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
  {
    display_name     = "LogixCCV-DEV"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://dchartview.logixhealth.com"
    logout_url       = "https://dchartview.logixhealth.com/"
    redirect_uris = [
      "https://dlogixccv.logixhealth.com/",
      "https://dccv.logixhealth.com/",
      "https://dchartview.logixhealth.com/",
      "https://localhost:50144/",
      "http://localhost:50144/"
    ]
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
  {
    display_name                   = "LogixReconciler-DEV"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://reconcilerd.logixhealth.com/LogixReconcilerApplication"
    logout_url                     = "https://reconcilerd.logixhealth.com/LogixReconcilerApplication/"
    redirect_uris                  = ["https://reconcilerd.logixhealth.com/LogixReconcilerApplication/", "https://reconcilerd.logixhealth.com/signin-oidc"]
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
  {
    display_name                   = "LogixCodify-DEV"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://codifyd.logixhealth.com/LogixCodifyApplication"
    logout_url                     = "https://codifyd.logixhealth.com/LogixCodifyApplication/"
    redirect_uris                  = ["https://codifyd.logixhealth.com/LogixCodifyApplication/"]
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
  {
    display_name     = "LogixExpress-DEV"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://expressd.logixhealth.com/LogixExpressApplication"
    logout_url       = "https://expressd.logixhealth.com/LogixExpressApplication/"
    redirect_uris = [
      "https://expressd.logixhealth.com/LogixExpressApplication/",
      "https://localhost:44358/",
      "https://localhost:44358/signin-oidc",
      "https://localhost/LAWApplication/"
    ]
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
  {
    display_name     = "LogixRequest-DEV"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://drequest.logixhealth.com"
    logout_url       = "https://drequest.logixhealth.com/"
    redirect_uris = [
      "https://drequest.logixhealth.com/",
      "https://drequest.logixhealth.com/signin-oidc",
      "https://localhost:7204/",
      "https://localhost:7204/signin-oidc"
    ]
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
  {
    display_name                   = "LogixRequestCCV-DEV"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://drequestccv.logixhealth.com"
    logout_url                     = "https://drequestccv.logixhealth.com/"
    redirect_uris                  = ["https://drequestccv.logixhealth.com/"]
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
  {
    display_name     = "LogixHRMS-DEV"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://dhrms.logixhealth.com"
    logout_url       = "https://dhrms.logixhealth.com/"
    redirect_uris = [
      "https://dhrms.logixhealth.com/",
      "https://dhrms.logixhealth.com/bsc/",
      "https://dhrms.logixhealth.com/EmpInfo/",
      "https://dhrms.logixhealth.com/Learning/",
      "https://dhrms.logixhealth.com/Exemption/",
      "https://dhrms.logixhealth.com/Exemption/signin-oidc",
      "https://dhrms.logixhealth.com/RolesAndPermissions/",
      "https://dhrms.logixhealth.com/RolesAndPermissions/signin-oidc",
      "https://localhost/Exemption/",
      "https://localhost/Exemption/signin-oidc",
      "https://localhost/RolesAndPermissions/",
      "https://localhost/RolesAndPermissions/signin-oidc",
      "https://localhost:57030/",
      "https://localhost:57030/signin-oidc",
      "https://localhost:57730/",
      "https://localhost:57730/signin-oidc"
    ]
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
  {
    display_name                   = "LogixScheduler-DEV"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://dscheduler.logixhealth.com"
    logout_url                     = "https://dscheduler.logixhealth.com/"
    redirect_uris                  = ["https://dscheduler.logixhealth.com/"]
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
  {
    display_name     = "LogixRefunds-DEV"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://drefunds.logixhealth.com"
    logout_url       = "https://drefunds.logixhealth.com/"
    redirect_uris    = []
    identifier_uris  = ["api://fb94272d-9129-4314-958c-7a1670109373"]
    single_page_app_redirect_uris = [
      "https://drefunds.logixhealth.com/",
      "https://localhost:4200/"
    ]
    tags                           = ["HideApp", "WindowsAzureActiveDirectoryIntegratedApp"]
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
        },
        {
          name                  = "sid"
          source                = null
          essential             = false
          additional_properties = []
        }
      ],
      access_token = [
        {
          name                  = "aud"
          source                = null
          essential             = false
          additional_properties = []
        },
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
      saml2_token = []
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
    display_name                   = "LogixRemitParser-DEV"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://dremitparser.logixhealth.com"
    logout_url                     = "https://dremitparser.logixhealth.com/"
    identifier_uris                = ["api://660b4e48-97de-4c5e-abcc-89ce1b77c9b6"]
    redirect_uris                  = []
    single_page_app_redirect_uris  = ["https://dremitparser.logixhealth.com/"]
    tags                           = ["HideApp", "WindowsAzureActiveDirectoryIntegratedApp"]
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
    display_name                   = "LogixNCV-DEV"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://dlogixncv.logixhealth.com/Application"
    logout_url                     = "https://dlogixncv.logixhealth.com/Application/"
    redirect_uris                  = ["https://dlogixncv.logixhealth.com/Application/"]
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
  {
    display_name                   = "LogixNCMS-DEV"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://dncms.logixhealth.com"
    logout_url                     = "https://dncms.logixhealth.com/"
    redirect_uris                  = ["https://dncms.logixhealth.com/"]
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
  }
]
