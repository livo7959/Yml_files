applications = [
  {
    display_name     = "LogixDenials-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://udenials.logixhealth.com"
    logout_url       = "https://udenials.logixhealth.com/"
    redirect_uris = [
      "https://udenials.logixhealth.com/",
      "https://udenials.logixhealth.com/signin-oidc"
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
    display_name     = "LogixPaidRight-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://ulogixpaidright.logixhealth.com/application"
    logout_url       = "https://ulogixpaidright.logixhealth.com/application/"
    redirect_uris = [
      "https://ulogixpaidright.logixhealth.com/application/",
      "https://ulogixpaidright.logixhealth.com/application/signin-oidc"
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
    display_name     = "LogixEnrollment-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://uenrollment.logixhealth.com"
    logout_url       = "https://uenrollment.logixhealth.com/"
    redirect_uris = [
      "https://uenrollment.logixhealth.com/",
      "https://uenrollment.logixhealth.com/signin-oidc",
      "https://uenrollment.logixhealth.com/LogixEnrollment/"
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
    display_name     = "LogixLockboxDocs-UAT"
    identifier_uris  = ["api://ae42f407-fd36-45e0-95d8-1f16f358a8bd"]
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://ulockboxdocs.logixhealth.com"
    logout_url       = "https://ulockboxdocs.logixhealth.com/"
    redirect_uris    = []
    single_page_app_redirect_uris = [
      "https://ulockboxdocs.logixhealth.com/"
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
    display_name     = "LogixClaimStatus-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://uclaimstatus.logixhealth.com"
    logout_url       = "https://uclaimstatus.logixhealth.com/"
    redirect_uris = [
      "https://uclaimstatus.logixhealth.com/",
      "https://uclaimstatus.logixhealth.com/signin-oidc"
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
    display_name     = "LogixEligibility-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://ueligibility.logixhealth.com"
    logout_url       = "https://ueligibility.logixhealth.com/"
    redirect_uris = [
      "https://ueligibility.logixhealth.com/",
      "https://ueligibility.logixhealth.com/signin-oidc"
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
    display_name     = "LogixProjection-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://uprojection.logixhealth.com"
    logout_url       = "https://uprojection.logixhealth.com/"
    redirect_uris = [
      "https://uprojection.logixhealth.com/",
      "https://uprojection.logixhealth.com/signin-oidc"
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
    display_name     = "LogixLearning-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://ulearning.logixhealth.com"
    logout_url       = "https://ulearning.logixhealth.com/learning/"
    redirect_uris = [
      "https://ulearning.logixhealth.com/learning/",
      "https://ulearning.logixhealth.com/training/"
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
    display_name     = "LogixPM-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://ulogixpm.logixhealth.com"
    logout_url       = "https://ulogixpm.logixhealth.com/"
    redirect_uris = [
      "https://ulogixpm.logixhealth.com/",
      "https://ulogixpm.logixhealth.com/signin-oidc"
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
    display_name     = "LogixStaffing-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://ustaffing.logixhealth.com/LogixStaffing"
    logout_url       = "https://ustaffing.logixhealth.com/LogixStaffing/"
    redirect_uris = [
      "https://ustaffing.logixhealth.com/LogixStaffing/"
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
    display_name     = "LogixStaffing2-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://u2staffing.logixhealth.com/LogixStaffing"
    logout_url       = "https://u2staffing.logixhealth.com/LogixStaffing/"
    redirect_uris = [
      "https://u2staffing.logixhealth.com/LogixStaffing/"
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
    display_name     = "LogixConnect-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://uconnect.logixhealth.com/ConnectPortal"
    logout_url       = "https://uconnect.logixhealth.com/ConnectPortal/"
    redirect_uris = [
      "https://uconnect.logixhealth.com/ConnectPortal/",
      "https://uconnect.logixhealth.com/help/",
      "https://uconnect.logixhealth.com/ConnectPortal/signin-oidc",
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
    display_name     = "LogixReporting-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://ureporting.logixhealth.com/"
    logout_url       = "https://ureporting.logixhealth.com/"
    redirect_uris = [
      "https://ureporting.logixhealth.com/",
      "https://ureporting.logixhealth.com/signin-oidc"
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
    display_name     = "LogixDemo-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://demo.logixhealth.com"
    logout_url       = "https://demo.logixhealth.com/"
    redirect_uris = [
      "https://demo.logixhealth.com/"
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
    display_name     = "Settings-Reporting-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://settings.ureporting.logixhealth.com"
    logout_url       = "https://settings.ureporting.logixhealth.com/"
    redirect_uris = [
      "https://settings.ureporting.logixhealth.com/"
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
    display_name     = "LogixFeedback-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://ufeedback.logixhealth.com/Feedback"
    logout_url       = "https://ufeedback.logixhealth.com/Feedback/"
    redirect_uris = [
      "https://ufeedback.logixhealth.com/Feedback/"
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
    display_name     = "LogixCCV-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://uchartview.logixhealth.com"
    logout_url       = "https://uchartview.logixhealth.com/"
    redirect_uris = [
      "https://ulogixccv.logixhealth.com/",
      "https://uchartview.logixhealth.com/",
      "https://uccv.logixhealth.com/"
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
    display_name     = "LogixReconciler-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://ureconciler.logixhealth.com/LogixReconcilerApplication"
    logout_url       = "https://ureconciler.logixhealth.com/LogixReconcilerApplication/"
    redirect_uris = [
      "https://ureconciler.logixhealth.com/LogixReconcilerApplication/",
      "https://ureconciler.logixhealth.com/signin-oidc"
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
    display_name     = "LogixCodify-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://ucodify.logixhealth.com/LogixCodifyApplication"
    logout_url       = "https://ucodify.logixhealth.com/LogixCodifyApplication/"
    redirect_uris = [
      "https://ucodify.logixhealth.com/LogixCodifyApplication/"
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
    display_name     = "LogixExpress-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://uexpress.logixhealth.com/LogixExpressApplication"
    logout_url       = "https://uexpress.logixhealth.com/LogixExpressApplication/"
    redirect_uris = [
      "https://uexpress.logixhealth.com/LogixExpressApplication/"
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
    display_name     = "LogixRequest-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://urequest.logixhealth.com"
    logout_url       = "https://urequest.logixhealth.com/"
    redirect_uris = [
      "https://urequest.logixhealth.com/",
      "https://urequest.logixhealth.com/signin-oidc"
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
    display_name     = "LogixRequestCCV-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://urequestccv.logixhealth.com"
    logout_url       = "https://urequestccv.logixhealth.com/"
    redirect_uris = [
      "https://urequestccv.logixhealth.com/"
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
    display_name     = "LogixHRMS-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://uhrms.logixhealth.com"
    logout_url       = "https://uhrms.logixhealth.com/"
    redirect_uris = [
      "https://uhrms.logixhealth.com/",
      "https://uhrms.logixhealth.com/bsc/",
      "https://uhrms.logixhealth.com/EmpInfo/",
      "https://uhrms.logixhealth.com/Learning/",
      "https://uhrms.logixhealth.com/Exemption/",
      "https://uhrms.logixhealth.com/Exemption/signin-oidc",
      "https://uhrms.logixhealth.com/RolesAndPermissions/",
      "https://uhrms.logixhealth.com/RolesAndPermissions/signin-oidc"
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
    display_name     = "LogixScheduler-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://uscheduler.logixhealth.com"
    logout_url       = "https://uscheduler.logixhealth.com/"
    redirect_uris = [
      "https://uscheduler.logixhealth.com/"
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
    display_name     = "LogixRefunds-UAT"
    identifier_uris  = ["api://c7951d6d-3ba3-49c4-aa35-24412c3fe3c6"]
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://urefunds.logixhealth.com"
    logout_url       = "https://urefunds.logixhealth.com/"
    redirect_uris    = []
    single_page_app_redirect_uris = [
      "https://urefunds.logixhealth.com/"
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
    display_name     = "LogixRemitParser-UAT"
    identifier_uris  = ["api://aa95d84d-daee-47de-bf2a-c3b861a54a32"]
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://uremitparser.logixhealth.com"
    logout_url       = "https://uremitparser.logixhealth.com/"
    redirect_uris    = []
    single_page_app_redirect_uris = [
      "https://uremitparser.logixhealth.com/"
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
    display_name     = "LogixNCV-UAT"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://ulogixncv.logixhealth.com/Application"
    logout_url       = "https://ulogixncv.logixhealth.com/Application/"
    redirect_uris = [
      "https://ulogixncv.logixhealth.com/Application/"
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
  }
]
