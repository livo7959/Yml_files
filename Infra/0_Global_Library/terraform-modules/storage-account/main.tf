# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "storage_account" {
  name                              = "lh${var.name}"
  resource_group_name               = var.resource_group
  location                          = module.common_constants.region_short_name_to_long_name[var.location]
  account_tier                      = var.account_tier
  access_tier                       = var.access_tier
  account_replication_type          = var.account_replication_type
  account_kind                      = var.account_kind
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled

  min_tls_version                 = var.min_tls_version
  allow_nested_items_to_be_public = var.public_nested_items_allowed
  public_network_access_enabled   = var.public_network_access_enabled
  shared_access_key_enabled       = var.shared_access_key_enabled
  large_file_share_enabled        = var.account_kind != "BlockBlobStorage" && contains(["LRS", "ZRS"], var.account_replication_type)

  sftp_enabled                     = var.sftp_enabled
  nfsv3_enabled                    = var.nfsv3_enabled
  is_hns_enabled                   = var.nfsv3_enabled || var.sftp_enabled ? true : var.hns_enabled
  cross_tenant_replication_enabled = var.cross_tenant_replication_enabled
  https_traffic_only_enabled       = var.nfsv3_enabled ? false : var.https_traffic_only_enabled

  tags = local.merged_tags

  dynamic "network_rules" {
    for_each = var.network_rules

    content {
      default_action             = each.default_action
      bypass                     = each.bypass
      ip_rules                   = each.ip_rules
      virtual_network_subnet_ids = each.virtual_network_subnet_ids
    }
  }

  dynamic "identity" {
    for_each = var.identity_type == null ? [] : ["enabled"]
    content {
      type         = var.identity_type
      identity_ids = var.identity_ids == "UserAssigned" ? var.identity_ids : null
    }
  }

  dynamic "static_website" {
    for_each = var.static_website_config == null ? [] : ["enabled"]
    content {
      index_document     = var.static_website_config.index_document
      error_404_document = var.static_website_config.error_404_document
    }
  }

  dynamic "custom_domain" {
    for_each = var.custom_domain_name != null ? ["enabled"] : []
    content {
      name          = var.custom_domain_name
      use_subdomain = var.use_subdomain
    }
  }

  dynamic "blob_properties" {
    for_each = (
      var.account_kind != "FileStorage" && (var.storage_blob_data_protection != null || var.storage_blob_cors_rule != null) ? ["enabled"] : []
    )

    content {
      change_feed_enabled      = var.nfsv3_enabled || var.sftp_enabled ? false : var.storage_blob_data_protection.change_feed_enabled
      versioning_enabled       = var.nfsv3_enabled || var.sftp_enabled ? false : var.storage_blob_data_protection.versioning_enabled
      last_access_time_enabled = var.nfsv3_enabled || var.sftp_enabled ? false : var.storage_blob_data_protection.last_access_time_enabled

      dynamic "cors_rule" {
        for_each = var.storage_blob_cors_rule != null ? ["enabled"] : []
        content {
          allowed_headers    = var.storage_blob_cors_rule.allowed_headers
          allowed_methods    = var.storage_blob_cors_rule.allowed_methods
          allowed_origins    = var.storage_blob_cors_rule.allowed_origins
          exposed_headers    = var.storage_blob_cors_rule.exposed_headers
          max_age_in_seconds = var.storage_blob_cors_rule.max_age_in_seconds
        }
      }

      dynamic "delete_retention_policy" {
        for_each = var.storage_blob_data_protection.delete_retention_policy_in_days > 0 ? ["enabled"] : []
        content {
          days = var.storage_blob_data_protection.delete_retention_policy_in_days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = var.storage_blob_data_protection.container_delete_retention_policy_in_days > 0 ? ["enabled"] : []
        content {
          days = var.storage_blob_data_protection.container_delete_retention_policy_in_days
        }
      }
    }
  }

  dynamic "share_properties" {
    for_each = var.file_share_retention_policy_in_days != null || var.file_share_properties_smb != null ? ["enabled"] : []
    content {
      dynamic "retention_policy" {
        for_each = var.file_share_retention_policy_in_days != null ? ["enabled"] : []
        content {
          days = var.file_share_retention_policy_in_days
        }
      }

      dynamic "smb" {
        for_each = var.file_share_properties_smb != null ? ["enabled"] : []
        content {
          authentication_types            = var.file_share_properties_smb.authentication_types
          channel_encryption_type         = var.file_share_properties_smb.channel_encryption_type
          kerberos_ticket_encryption_type = var.file_share_properties_smb.kerberos_ticket_encryption_type
          versions                        = var.file_share_properties_smb.versions
          multichannel_enabled            = var.file_share_properties_smb.multichannel_enabled
        }
      }
    }
  }

  dynamic "azure_files_authentication" {
    for_each = var.file_share_authentication != null ? ["enabled"] : []
    content {
      directory_type = var.file_share_authentication.directory_type
      dynamic "active_directory" {
        for_each = var.file_share_authentication.directory_type == "AD" ? [var.file_share_authentication.active_directory] : []
        content {
          domain_guid         = each.value.domain_guid
          domain_name         = each.value.domain_name
          domain_sid          = each.value.domain_sid
          forest_name         = each.value.forest_name
          netbios_domain_name = each.value.netbios_domain_name
          storage_sid         = each.value.storage_sid
        }
      }
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/Azurerm/latest/docs/resources/storage_container
resource "azurerm_storage_container" "container" {
  for_each = try({ for c in var.containers : c.name => c }, {})

  storage_account_name = azurerm_storage_account.storage_account.name

  name                  = each.key
  container_access_type = each.value.container_access_type
  metadata              = each.value.metadata
}

# https://registry.terraform.io/providers/hashicorp/Azurerm/latest/docs/resources/advanced_threat_protection
resource "azurerm_advanced_threat_protection" "threat_protection" {
  enabled            = var.advanced_threat_protection_enabled
  target_resource_id = azurerm_storage_account.storage_account.id
}
