resource "azuread_conditional_access_policy" "ca700" {
  display_name = local.ca_policies.CA700.name
  state        = "enabled"

  conditions {
    client_app_types = ["all"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_guests_or_external_users {
        guest_or_external_user_types = [
          "b2bCollaborationGuest",
          "b2bCollaborationMember",
          "b2bDirectConnectUser",
          "internalGuest",
          "serviceProvider"
        ]

        external_tenants {
          membership_kind = "all"
        }
      }

      excluded_users = [azuread_group.exemption_group["CA700"].object_id]


    }

  }
  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }
  depends_on = [azuread_group.exemption_group]
}
