resource "azuread_conditional_access_policy" "ca200" {
  display_name = local.ca_policies.CA200.name
  state        = "enabled"

  conditions {
    client_app_types = ["all"]

    applications {
      included_applications = ["All"]
    }

    users {
      excluded_groups = [azuread_group.emergency_access_group.id, azuread_group.exemption_group["CA200"].object_id]
      included_roles = [
        local.application_administrator,
        local.application_developer,
        local.cloud_application_adminstrator,
        local.cloud_device_administrator,
        local.conditional_access_administrator,
        local.exchange_administrator,
        local.global_administrator,
        local.global_reader,
        local.global_secure_access_administrator,
        local.helpdesk_administrator,
        local.intune_administrator,
        local.password_administrator,
        local.privileged_role_administrator,
        local.priviliged_authetication_administrator,
        local.security_administrator,
        local.security_operator,
        local.security_reader,
        local.sharepoint_administrator,
        local.user_administrator
      ]
    }
  }

  session_controls {
    persistent_browser_mode    = "never"
    sign_in_frequency          = 16
    sign_in_frequency_interval = "timeBased"
    sign_in_frequency_period   = "hours"
  }
}
