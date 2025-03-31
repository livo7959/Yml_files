data "databricks_group" "data_engineering_data_developer" {
  display_name = "data_engineering_data_developer"
}

data "databricks_group" "edi_dept" {
  display_name = "EDI_Department"
}

data "databricks_user" "kryan" {
  user_name = "kryan@logixhealth.com"
}

data "databricks_user" "nmiller" {
  user_name = "nmiller@logixhealth.com"
}

data "databricks_user" "olitvak" {
  user_name = "olitvak@logixhealth.com"
}

data "databricks_user" "ykurgan" {
  user_name = "ykurgan@logixhealth.com"
}

data "databricks_service_principal" "sp-azdo-lhCorpShared001" {
  application_id = "cac9cc79-3640-4b69-9829-537d2b0412b9"
}

data "databricks_service_principal" "sp-azdo-lhSandboxData001" {
  application_id = "55add8b0-dfb8-45e9-8245-7955eb9cc0aa"
}

data "databricks_service_principal" "sp-azdo-lhCorpDev001" {
  application_id = "24441fc3-b25e-4a43-b4fe-ed4636775410"
}

data "databricks_service_principal" "sp-azdo-lhCorpProd001" {
  application_id = "d2c6f69d-46a7-4b45-a861-80f96599e67d"
}

resource "databricks_service_principal" "sp-databricks-fivetran-sbox" {
  application_id = "a7b73f9d-7703-425c-b8fb-e325eac24b5e"
  display_name   = "sp-databricks-fivetran-sbox"
}

resource "databricks_service_principal" "sp-databricks-fivetran-stg" {
  application_id = "23319b0a-1ad1-4f74-821e-0e3ca05dc54a"
  display_name   = "sp-databricks-fivetran-stg"
}

resource "databricks_service_principal" "sp-databricks-fivetran-prod" {
  application_id = "24c78857-6da5-4861-874e-44b8a78c4682"
  display_name   = "sp-databricks-fivetran-prod"
}

resource "databricks_group" "raw_fhir_readers" {
  display_name = "raw_fhir_readers"
}

resource "databricks_group_member" "raw_fhir_reader_kryan" {
  group_id  = databricks_group.raw_fhir_readers.id
  member_id = data.databricks_user.kryan.id
}

resource "databricks_group_member" "raw_fhir_reader_nmiller" {
  group_id  = databricks_group.raw_fhir_readers.id
  member_id = data.databricks_user.nmiller.id
}

resource "databricks_group_member" "raw_fhir_reader_olitvak" {
  group_id  = databricks_group.raw_fhir_readers.id
  member_id = data.databricks_user.olitvak.id
}

resource "databricks_group_member" "raw_fhir_reader_ykurgan" {
  group_id  = databricks_group.raw_fhir_readers.id
  member_id = data.databricks_user.ykurgan.id
}

locals {
  envs = {
    sbox = {
      workspace_id = 6677558479261806
      admin_members = [
        data.databricks_service_principal.sp-azdo-lhCorpShared001.id,
        data.databricks_service_principal.sp-azdo-lhSandboxData001.id,
      ]
      workspace_users = [
        databricks_group.raw_fhir_readers.id,
        data.databricks_group.data_engineering_data_developer.id,
        databricks_service_principal.sp-databricks-fivetran-sbox.id
      ]
      bronze_data_writer_members = [
        databricks_group.databricks_account_admin.id,
        data.databricks_group.data_engineering_data_developer.id,
      ]
      silver_data_writer_members = []
      gold_data_writer_members   = []
    }
    stg = {
      workspace_id = 2713822203036682
      admin_members = [
        data.databricks_service_principal.sp-azdo-lhCorpShared001.id,
        data.databricks_service_principal.sp-azdo-lhCorpDev001.id,
      ]
      workspace_users = [
        databricks_group.raw_fhir_readers.id,
        data.databricks_group.edi_dept.id,
        data.databricks_group.data_engineering_data_developer.id,
        databricks_service_principal.sp-databricks-fivetran-stg.id,
      ]
      bronze_data_writer_members = [
        databricks_group.databricks_account_admin.id,
        data.databricks_group.data_engineering_data_developer.id,
      ]
      silver_data_writer_members = []
      gold_data_writer_members   = []
    }
    prod = {
      workspace_id = 509690184712866
      admin_members = [
        data.databricks_service_principal.sp-azdo-lhCorpShared001.id,
        data.databricks_service_principal.sp-azdo-lhCorpProd001.id
      ]
      workspace_users = [
        data.databricks_group.data_engineering_data_developer.id,
        databricks_service_principal.sp-databricks-fivetran-prod.id,
      ]
      bronze_data_writer_members = []
      silver_data_writer_members = []
      gold_data_writer_members   = []
    }
  }
}

resource "databricks_metastore" "dbx_metastore" {
  provider      = databricks.accounts
  name          = "eastus metastore"
  storage_root  = "abfss://metastore@unitycatalogeusshared.dfs.core.windows.net/"
  region        = var.location
  force_destroy = false
}

resource "databricks_metastore_assignment" "metastore_workspace_assignment" {
  for_each = local.envs

  metastore_id = databricks_metastore.dbx_metastore.id
  workspace_id = each.value.workspace_id
}

resource "databricks_group" "databricks_account_admin" {
  display_name = "databricks_account_admin"
}

resource "databricks_group_role" "databricks_account_admin" {
  group_id = databricks_group.databricks_account_admin.id
  role     = "account_admin"
}

resource "databricks_group" "databricks_admin" {
  for_each = local.envs

  display_name = "databricks_${each.key}_admin"
}

resource "databricks_group" "databricks_bronze_data_writer" {
  for_each = local.envs

  display_name = "databricks_bronze_data_writer_${each.key}"
}

resource "databricks_group" "databricks_silver_data_writer" {
  for_each = local.envs

  display_name = "databricks_silver_data_writer_${each.key}"
}

resource "databricks_group" "databricks_gold_data_writer" {
  for_each = local.envs

  display_name = "databricks_gold_data_writer_${each.key}"
}

resource "databricks_group_member" "databricks_admin_members" {
  for_each = {
    for each in flatten([
      for env, env_config in local.envs : [
        for admin_member in env_config.admin_members : {
          env          = env
          admin_member = admin_member
        }
      ]
    ]) : "${each.env}-${each.admin_member}" => each
  }

  group_id  = databricks_group.databricks_admin[each.value.env].id
  member_id = each.value.admin_member
}

resource "databricks_group_member" "databricks_bronze_data_writer_members" {
  for_each = {
    for each in flatten([
      for env, env_config in local.envs : [
        for bronze_data_writer_member in env_config.bronze_data_writer_members : {
          env                       = env
          bronze_data_writer_member = bronze_data_writer_member
        }
      ]
    ]) : "${each.env}-${each.bronze_data_writer_member}" => each
  }

  group_id  = databricks_group.databricks_bronze_data_writer[each.value.env].id
  member_id = each.value.bronze_data_writer_member
}

resource "databricks_group_member" "databricks_silver_data_writer_members" {
  for_each = {
    for each in flatten([
      for env, env_config in local.envs : [
        for silver_data_writer_member in env_config.silver_data_writer_members : {
          env                       = env
          silver_data_writer_member = silver_data_writer_member
        }
      ]
    ]) : "${each.env}-${each.silver_data_writer_member}" => each
  }

  group_id  = databricks_group.databricks_silver_data_writer[each.value.env].id
  member_id = each.value.silver_data_writer_member
}

resource "databricks_group_member" "databricks_gold_data_writer_members" {
  for_each = {
    for each in flatten([
      for env, env_config in local.envs : [
        for gold_data_writer_member in env_config.gold_data_writer_members : {
          env                     = env
          gold_data_writer_member = gold_data_writer_member
        }
      ]
    ]) : "${each.env}-${each.gold_data_writer_member}" => each
  }

  group_id  = databricks_group.databricks_gold_data_writer[each.value.env].id
  member_id = each.value.gold_data_writer_member
}

resource "databricks_mws_permission_assignment" "workspace_admin" {
  for_each = local.envs

  workspace_id = each.value.workspace_id
  principal_id = databricks_group.databricks_admin[each.key].id
  permissions  = ["ADMIN"]
}

resource "databricks_mws_permission_assignment" "workspace_user" {
  for_each = {
    for each in flatten([
      for env, env_config in local.envs : [
        for workspace_user in env_config.workspace_users : {
          env            = env
          workspace_id   = env_config.workspace_id
          workspace_user = workspace_user
        }
      ]
    ]) : "${each.env}-${each.workspace_user}" => each
  }

  workspace_id = each.value.workspace_id
  principal_id = each.value.workspace_user
  permissions  = ["USER"]
}

resource "databricks_mws_permission_assignment" "workspace_user_group_databricks_bronze_data_writer" {
  for_each = local.envs

  workspace_id = each.value.workspace_id
  principal_id = databricks_group.databricks_bronze_data_writer[each.key].id
  permissions  = ["USER"]
}
