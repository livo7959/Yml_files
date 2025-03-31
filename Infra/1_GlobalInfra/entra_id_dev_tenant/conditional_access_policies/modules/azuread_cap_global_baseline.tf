resource "azuread_conditional_access_policy" "ca100" {
  display_name = local.ca_policies.CA100.name
  state        = "enabled"

  conditions {
    client_app_types = ["all"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_users  = ["All"]
      excluded_users  = ["GuestsOrExternalUsers"]
      excluded_groups = [azuread_group.emergency_access_group.id, azuread_group.exemption_group["CA100"].object_id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }
  depends_on = [azuread_group.exemption_group]
}

resource "azuread_conditional_access_policy" "ca101" {
  display_name = local.ca_policies.CA101.name
  state        = "enabled"

  conditions {
    client_app_types = ["all"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.emergency_access_group.id, azuread_group.exemption_group["CA101"].object_id]
    }

    locations {
      included_locations = ["All"]
      excluded_locations = [
        azuread_named_location.azure_trusted_ips.id,
        azuread_named_location.bangalore.id,
        azuread_named_location.trusted_countries.id,
        azuread_named_location.bedford.id,
        azuread_named_location.coimbatore.id,
        azuread_named_location.trusted_countries.id
      ]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
  depends_on = [azuread_group.exemption_group]
}

resource "azuread_conditional_access_policy" "ca102" {
  display_name = local.ca_policies.CA102.name
  state        = "enabled"

  conditions {
    client_app_types = ["exchangeActiveSync", "other"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.emergency_access_group.id, azuread_group.exemption_group["CA102"].object_id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
  depends_on = [azuread_group.exemption_group]
}

resource "azuread_conditional_access_policy" "ca103" {
  display_name = local.ca_policies.CA103.name
  state        = "enabled"

  conditions {
    client_app_types = ["all"]

    applications {
      included_applications = ["All"]
    }
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.emergency_access_group.id, azuread_group.exemption_group["CA103"].object_id]
    }

    platforms {
      included_platforms = ["all"]
      excluded_platforms = ["android", "iOS", "linux", "macOS", "windows"]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
  depends_on = [azuread_group.exemption_group]
}

resource "azuread_conditional_access_policy" "ca104" {
  display_name = local.ca_policies.CA104.name
  state        = "enabled"

  conditions {
    client_app_types = ["all"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.emergency_access_group.id, azuread_group.exemption_group["CA104"].object_id]
    }

    sign_in_risk_levels = ["low", "medium"]
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }
  depends_on = [azuread_group.exemption_group]
}

resource "azuread_conditional_access_policy" "ca105" {
  display_name = local.ca_policies.CA105.name
  state        = "enabled"

  conditions {
    client_app_types = ["all"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.emergency_access_group.id, azuread_group.exemption_group["CA105"].object_id]
    }

    sign_in_risk_levels = ["high"]
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
  depends_on = [azuread_group.exemption_group]
}

resource "azuread_conditional_access_policy" "ca106" {
  display_name = local.ca_policies.CA106.name
  state        = "enabled"

  conditions {
    client_app_types = ["all"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.emergency_access_group.id, azuread_group.exemption_group["CA106"].object_id]
    }

    user_risk_levels = ["low", "medium"]
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }
  depends_on = [azuread_group.exemption_group]
}

resource "azuread_conditional_access_policy" "ca107" {
  display_name = local.ca_policies.CA107.name
  state        = "enabled"

  conditions {
    client_app_types = ["all"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.emergency_access_group.id, azuread_group.exemption_group["CA107"].object_id]
    }

    user_risk_levels = ["high"]
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
  depends_on = [azuread_group.exemption_group]
}
