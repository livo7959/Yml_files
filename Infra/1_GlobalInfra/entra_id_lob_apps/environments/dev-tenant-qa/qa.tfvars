applications = [
  {
    display_name                   = "LogixDenial-QA"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://qdenials.logixhealth.com"
    logout_url                     = "https://qdenials.logixhealth.com/"
    redirect_uris                  = ["https://qdenials.logixhealth.com/", "https://qdenials.logixhealth.com/signin-oidc"]
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
    display_name     = "LogixPaidRight-QA"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://qlogixpaidright.logixhealth.com/application"
    logout_url       = "https://qlogixpaidright.logixhealth.com/application/"
    redirect_uris = [
      "https://qlogixpaidright.logixhealth.com/application/",
      "https://qlogixpaidright.logixhealth.com/application/signin-oidc"
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
    display_name                   = "LogixEnrollment-QA"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://qenrollment.logixhealth.com"
    logout_url                     = "https://qenrollment.logixhealth.com/"
    redirect_uris                  = ["https://qenrollment.logixhealth.com/", "https://qenrollment.logixhealth.com/LogixEnrollment/", "https://qenrollment.logixhealth.com/signin-oidc"]
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
    display_name                   = "LogixLockboxDocs-QA"
    identifier_uris                = ["api://67f77bdd-4cf1-49bc-aad1-2ddee4c3fde8"]
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://qlockboxdocs.logixhealth.com"
    logout_url                     = "https://qlockboxdocs.logixhealth.com/"
    redirect_uris                  = []
    single_page_app_redirect_uris  = ["https://qlockboxdocs.logixhealth.com/"]
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
    display_name                   = "LogixClaimStatus-QA"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://qclaimstatus.logixhealth.com"
    logout_url                     = "https://qclaimstatus.logixhealth.com/"
    redirect_uris                  = ["https://qclaimstatus.logixhealth.com/", "https://qclaimstatus.logixhealth.com/signin-oidc"]
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
    display_name                   = "LogixEligibility-QA"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://qeligibility.logixhealth.com"
    logout_url                     = "https://qeligibility.logixhealth.com/"
    redirect_uris                  = ["https://qeligibility.logixhealth.com/", "https://qeligibility.logixhealth.com/signin-oidc"]
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
    display_name                   = "LogixProjection-QA"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://qprojection.logixhealth.com"
    logout_url                     = "https://qprojection.logixhealth.com/"
    redirect_uris                  = ["https://qprojection.logixhealth.com/", "https://qprojection.logixhealth.com/signin-oidc"]
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
    display_name                   = "LogixLearning-QA"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://qlearning.logixhealth.com"
    logout_url                     = "https://qlearning.logixhealth.com/learning/"
    redirect_uris                  = ["https://qlearning.logixhealth.com/learning/", "https://qlearning.logixhealth.com/training/"]
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
    display_name                   = "LogixPM-QA"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://qlogixpm.logixhealth.com"
    logout_url                     = "https://qlogixpm.logixhealth.com/"
    redirect_uris                  = ["https://qlogixpm.logixhealth.com/", "https://qlogixpm.logixhealth.com/signin-oidc"]
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
    display_name                   = "LogixStaffing-QA"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://qstaffing.logixhealth.com/LogixStaffing"
    logout_url                     = "https://qstaffing.logixhealth.com/LogixStaffing/"
    redirect_uris                  = ["https://qstaffing.logixhealth.com/LogixStaffing/"]
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
    display_name                   = "LogixStaffing2-QA"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://qa2staffing.logixhealth.com/LogixStaffing"
    logout_url                     = "https://qa2staffing.logixhealth.com/LogixStaffing/"
    redirect_uris                  = ["https://qa2staffing.logixhealth.com/LogixStaffing/"]
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
    display_name     = "LogixConnect-QA"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://qconnect.logixhealth.com/ConnectPortal"
    logout_url       = "https://qconnect.logixhealth.com/ConnectPortal/"
    redirect_uris = [
      "https://qconnect.logixhealth.com/ConnectPortal/",
      "https://qconnect.logixhealth.com/help/",
      "https://qlhconnect.logixhealth.com/ConnectPortal/",
      "https://qlhconnect.logixhealth.com/help/",
      "https://qalhconnect.logixhealth.com/ConnectPortal/",
      "https://qalhconnect.logixhealth.com/help/",
      "https://qalhconnect.logixhealth.com/ConnectPortal/signin-oidc"
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
    display_name                   = "LogixReporting-QA"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://qreporting.logixhealth.com/"
    logout_url                     = "https://qreporting.logixhealth.com/"
    redirect_uris                  = ["https://qreporting.logixhealth.com/", "https://qreporting.logixhealth.com/signin-oidc"]
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
    display_name                   = "Settings-Reporting-QA"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://settings.qreporting.logixhealth.com"
    logout_url                     = "https://settings.qreporting.logixhealth.com/"
    redirect_uris                  = ["https://settings.qreporting.logixhealth.com/"]
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
    display_name                   = "LogixFeedback-QA"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://qfeedback.logixhealth.com/Feedback"
    logout_url                     = "https://qfeedback.logixhealth.com/Feedback/"
    redirect_uris                  = ["https://qfeedback.logixhealth.com/Feedback/"]
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
    display_name     = "LogixCCV-QA"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://qlogixccv.logixhealth.com"
    logout_url       = "https://qlogixccv.logixhealth.com/"
    redirect_uris = [
      "https://qlogixccv.logixhealth.com/",
      "https://qccv.logixhealth.com/"
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
    display_name                   = "LogixReconciler-QA"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://qreconciler.logixhealth.com/LogixReconcilerApplication"
    logout_url                     = "https://qreconciler.logixhealth.com/LogixReconcilerApplication/"
    redirect_uris                  = ["https://qreconciler.logixhealth.com/LogixReconcilerApplication/", "https://qreconciler.logixhealth.com/signin-oidc"]
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
    display_name                   = "LogixCodify-QA"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://qcodify.logixhealth.com/LogixCodifyApplication"
    logout_url                     = "https://qcodify.logixhealth.com/LogixCodifyApplication/"
    redirect_uris                  = ["https://qcodify.logixhealth.com/LogixCodifyApplication/"]
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
    display_name                   = "LogixExpress-QA"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://qexpress.logixhealth.com/LogixExpressApplication"
    logout_url                     = "https://qexpress.logixhealth.com/LogixExpressApplication/"
    redirect_uris                  = ["https://qexpress.logixhealth.com/LogixExpressApplication/"]
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
    display_name                   = "LogixRequest-QA"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://qrequest.logixhealth.com"
    logout_url                     = "https://qrequest.logixhealth.com/"
    redirect_uris                  = ["https://qrequest.logixhealth.com/", "https://qrequest.logixhealth.com/signin-oidc"]
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
    display_name                   = "LogixRequestCCV-QA"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://qrequestccv.logixhealth.com"
    logout_url                     = "https://qrequestccv.logixhealth.com/"
    redirect_uris                  = ["https://qrequestccv.logixhealth.com/"]
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
    display_name     = "LogixHRMS-QA"
    sign_in_audience = "AzureADMyOrg"
    homepage_url     = "https://qhrms.logixhealth.com"
    logout_url       = "https://qhrms.logixhealth.com/"
    redirect_uris = [
      "https://qhrms.logixhealth.com/",
      "https://qhrms.logixhealth.com/bsc",
      "https://qhrms.logixhealth.com/EmpInfo/",
      "https://qhrms.logixhealth.com/Learning/",
      "https://qhrms.logixhealth.com/RolesAndPermissions/",
      "https://qhrms.logixhealth.com/Exemption/",
      "https://qhrms.logixhealth.com/RolesAndPermissions/signin-oidc",
      "https://qhrms.logixhealth.com/Exemption/signin-oidc"
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
    display_name                   = "LogixScheduler-QA"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://qscheduler.logixhealth.com"
    logout_url                     = "https://qscheduler.logixhealth.com/"
    redirect_uris                  = ["https://qscheduler.logixhealth.com/"]
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
    display_name                   = "LogixRefunds-QA"
    identifier_uris                = ["api://41de6ef4-fe47-483c-9650-744b38be6386"]
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://qrefunds.logixhealth.com"
    logout_url                     = "https://qrefunds.logixhealth.com/"
    redirect_uris                  = []
    single_page_app_redirect_uris  = ["https://qrefunds.logixhealth.com/"]
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
    display_name                   = "LogixRemitParser-QA"
    identifier_uris                = ["api://9eb3a034-273b-4a32-9d2f-76aba456ab47"]
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://qremitparser.logixhealth.com"
    logout_url                     = "https://qremitparser.logixhealth.com/"
    redirect_uris                  = []
    single_page_app_redirect_uris  = ["https://qremitparser.logixhealth.com/"]
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
    display_name                   = "LogixNCV-QA"
    sign_in_audience               = "AzureADMyOrg"
    homepage_url                   = "https://qlogixncv.logixhealth.com/Application"
    logout_url                     = "https://qlogixncv.logixhealth.com/Application/"
    redirect_uris                  = ["https://qlogixncv.logixhealth.com/Application/"]
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
