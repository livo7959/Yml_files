# This file represents admin-level settings that appply to the entire Databricks workspace.

resource "databricks_restrict_workspace_admins_setting" "restrict_workspace_admins_setting" {
  restrict_workspace_admins {
    status = "RESTRICT_TOKENS_AND_JOB_RUN_AS"
  }
}

resource "databricks_default_namespace_setting" "default_catalog" {
  namespace {
    value = var.env
  }
}

# We must grant permissions to service pricipals in order for them to use personal access tokens.
# (This permission must be granted in the "databricks_workspace_metastore_admin" directory, because
# it is an account-level operation on a workspace.)
# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions#token-usage

resource "databricks_permissions" "token_usage" {
  authorization = "tokens"

  dynamic "access_control" {
    for_each = var.token_usage_permissions
    content {
      service_principal_name = access_control.value
      permission_level       = "CAN_USE"
    }
  }
}
