# ------------------
# Required variables
# ------------------

variable "name" {
  type = string
  # https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview#storage-account-name
  description = "Storage account names must be between 3 and 24 characters in length and may contain numbers and lowercase letters only. The name must be unique within Azure. No two storage accounts can have the same name. See the [documentation](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview#storage-account-name) for more information. Note that when creating the resource, the name provided will be prefixed with \"lh\" in order to provide namespacing."
  nullable    = false

  validation {
    condition     = var.name != null && length(var.name) >= 3
    error_message = "The name must have at least 3 characters."
  }
  validation {
    condition     = var.name != null && length(var.name) <= 24
    error_message = "The name must not have more than 24 characters."
  }
  validation {
    condition     = var.name != null && can(regex(module.common_constants.lowercase_and_numbers_regex, var.name))
    error_message = "The name must contain only lowercase letters and numbers."
  }
  validation {
    condition     = var.name != null && !startswith(var.name, "lh")
    error_message = "The name must not start with \"lh\". (A prefix of \"lh\" will automatically be added by this module when creating the resource.)"
  }

}

variable "location" {
  type        = string
  description = "Azure region short name (CAF). e.g. `eus` for East US. See: https://www.jlaundry.nz/2022/azure_region_abbreviations/"
  nullable    = false
  validation {
    condition     = contains(keys(module.common_constants.region_short_name_to_long_name), var.location)
    error_message = "The location must be one of: ${join(", ", keys(module.common_constants.region_short_name_to_long_name))}"
  }
}

variable "environment" {
  type        = string
  description = "Environment shortname"
  nullable    = false
  validation {
    condition     = contains(module.common_constants.valid_environments, var.environment)
    error_message = "The environment must be one of: ${join(", ", module.common_constants.valid_environments)}"
  }
}

variable "resource_group" {
  type        = string
  description = "Name of the resource group that this virtual network should be inside. Should be in the format of: `rg-foo`"
  nullable    = false
  validation {
    condition     = var.resource_group != null && can(regex(module.common_constants.kebab_case_regex, var.resource_group))
    error_message = "The resource group must be kebab-case."
  }
  validation {
    condition     = var.resource_group != null && startswith(var.resource_group, "rg-")
    error_message = "The resource group must start with \"rg-\"."
  }
}

# ------------------
# Optional variables
# ------------------

variable "tags" {
  type        = map(string)
  description = "Tags for the deployment. Tag names are case insensitive, but tag values are case sensitive. The `managedBy = \"terraform\"` tag will automatically be applied in addition to any other tags specified."
  default     = {}
  validation {
    condition = alltrue([
      for tag in var.tags :
      lower(tag) == tag
    ])
    error_message = "All tag names must be in lowercase."
  }
}

variable "account_kind" {
  description = "Defines the kind of account. Valid options are `BlobStorage`, `BlockBlobStorage`, `FileStorage`, `Storage` and `StorageV2`. Changing this forces a new resource to be created."
  type        = string
  default     = "StorageV2"
}

variable "account_tier" {
  description = "Defines the tier to use for this storage account. Valid options are `Standard` and `Premium`. For `BlockBlobStorage` and `FileStorage` accounts, only `Premium` is valid. Changing this forces a new resource to be created."
  type        = string
  default     = "Standard"
}

variable "access_tier" {
  description = "Defines the access tier for `BlobStorage`, `FileStorage` and `StorageV2` accounts. Valid options are `Hot` and `Cool`."
  type        = string
  default     = "Hot"
}

variable "account_replication_type" {
  # cspell:disable-next-line
  description = "Defines the type of replication to use for this Storage Account. Valid options are `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS` and `RAGZRS`."
  type        = string
  default     = "ZRS"
}

variable "https_traffic_only_enabled" {
  description = "Boolean flag which forces HTTPS if enabled."
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the storage account."
  type        = string
  default     = "TLS1_2"
}

variable "infrastructure_encryption_enabled" {
  description = "Enable or disable infrastructure encryption. Can only be set at creation time."
  type        = bool
  default     = false
}

variable "public_nested_items_allowed" {
  description = "Allow or disallow nested items within this Account to opt into being public."
  type        = bool
  default     = false
}

variable "custom_domain_name" {
  description = "The custom domain name to use for the Storage Account, which will be validated by Azure."
  type        = string
  default     = null
}

variable "use_subdomain" {
  description = "Whether the custom domain name is validated by using indirect CNAME validation."
  type        = bool
  default     = false
}

variable "static_website_config" {
  description = "Static website configuration. Can only be set when the `account_kind` is set to `StorageV2` or `BlockBlobStorage`."
  type = object({
    index_document     = optional(string)
    error_404_document = optional(string)
  })
  default = null
}

variable "shared_access_key_enabled" {
  description = "Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD)."
  type        = bool
  default     = true
}

variable "nfsv3_enabled" {
  description = "Whether NFSv3 protocol is enabled. Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

variable "sftp_enabled" {
  description = "Whether SFTP access is enabled."
  type        = bool
  default     = false
}

variable "hns_enabled" {
  description = "Whether hierarchical namespace is enabled. This can be used with Azure Data Lake Storage Gen 2 and must be `true` if `nfsv3_enabled` or `sftp_enabled` is set to `true`. Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

# Identity

variable "identity_type" {
  description = "Specifies the type of managed identity that should be configured on this storage account. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned` (to enable both)."
  type        = string
  default     = "SystemAssigned"
}

variable "identity_ids" {
  description = "Specifies a list of user-assigned managed identity IDs to be assigned to this storage account."
  type        = list(string)
  default     = null
}

variable "public_network_access_enabled" {
  description = "Enabled or disabled public network access."
  type        = bool
  default     = false
}

# Data protection

variable "storage_blob_data_protection" {
  description = "Storage account blob data protection parameters."
  type = object({
    change_feed_enabled                       = optional(bool, false)
    versioning_enabled                        = optional(bool, false)
    last_access_time_enabled                  = optional(bool, false)
    delete_retention_policy_in_days           = optional(number, 0)
    container_delete_retention_policy_in_days = optional(number, 0)
    container_point_in_time_restore           = optional(bool, false)
  })
  default = {
    change_feed_enabled                       = true
    last_access_time_enabled                  = true
    versioning_enabled                        = true
    delete_retention_policy_in_days           = 30
    container_delete_retention_policy_in_days = 30
    container_point_in_time_restore           = true
  }
}

variable "storage_blob_cors_rule" {
  description = "See the [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account#cors_rule) for more information."
  type = object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  })
  default = null
}

# Threat protection

variable "advanced_threat_protection_enabled" {
  description = "See the [documentation](https://docs.microsoft.com/en-us/azure/storage/common/storage-advanced-threat-protection?tabs=azure-portal) for more information."
  type        = bool
  default     = false
}

# Data creation/bootstrap

variable "containers" {
  description = "List of objects to create some blob containers in this storage account."
  type = list(object({
    name                  = string
    container_access_type = optional(string, "private")
    metadata              = optional(map(string))
  }))
  default = []
}

variable "file_shares" {
  description = "List of objects to create file shares in the storage account."
  type = list(object({
    name             = string
    quota_in_gb      = number
    enabled_protocol = optional(string)
    metadata         = optional(map(string))
    acl = optional(list(object({
      id          = string
      permissions = string
      start       = optional(string)
      expiry      = optional(string)
    })))
  }))
  default = []
}

variable "tables" {
  description = "List of objects to create some Tables in this Storage Account."
  type = list(object({
    name = string
    acl = optional(list(object({
      id          = string
      permissions = string
      start       = optional(string)
      expiry      = optional(string)
    })))
  }))
  default = []
}

variable "queues" {
  description = "List of objects to create some Queues in this Storage Account."
  type = list(object({
    name     = string
    metadata = optional(map(string))
  }))
  default = []
}

variable "queue_properties_logging" {
  description = "Logging queue properties"
  type = object({
    delete                = optional(bool, true)
    read                  = optional(bool, true)
    write                 = optional(bool, true)
    version               = optional(string, "1.0")
    retention_policy_days = optional(number, 10)
  })
  default = {}
}

variable "cross_tenant_replication_enabled" {
  description = "Enable cross tenant replication."
  type        = bool
  default     = false
}

# Storage firewall

variable "network_rules" {
  description = "Object with attributes: `bypass`, `default_action`, `ip_rules`, `virtual_network_subnet_ids`. Set to `null` to disable."
  type = list(object({
    bypass                     = optional(list(string), ["AzureServices"])
    default_action             = optional(string, "Deny")
    ip_rules                   = optional(list(string))
    virtual_network_subnet_ids = optional(list(string))
  }))
  default = []
}

variable "private_link_access" {
  description = "List of PrivateLink objects to allow access from."
  type = list(object({
    endpoint_resource_id = string
    endpoint_tenant_id   = optional(string, null)
  }))
  default  = []
  nullable = false
}

# File share variables

variable "file_share_retention_policy_in_days" {
  description = "Storage Account file shares retention policy in days. Enabling this may require additional directory permissions."
  type        = number
  default     = null
}

variable "file_share_properties_smb" {
  description = "Storage Account file shares smb properties."
  type = object({
    versions                        = optional(list(string), null)
    authentication_types            = optional(list(string), null)
    kerberos_ticket_encryption_type = optional(list(string), null)
    channel_encryption_type         = optional(list(string), null)
    multichannel_enabled            = optional(bool, null)
  })
  default = null
}

variable "file_share_authentication" {
  description = "Storage Account file shares authentication configuration."
  type = object({
    directory_type = string
    active_directory = optional(object({
      storage_sid         = string
      domain_name         = string
      domain_sid          = string
      domain_guid         = string
      forest_name         = string
      netbios_domain_name = string
    }))
  })
  default = null

  validation {
    condition = var.file_share_authentication == null || (
      contains(["AADDS", "AD", ""], try(var.file_share_authentication.directory_type, ""))
    )
    error_message = "`file_share_authentication.directory_type` can only be `AADDS` or `AD`."
  }

  validation {
    condition = var.file_share_authentication == null || (
      try(var.file_share_authentication.directory_type, null) == "AADDS" || (
        try(var.file_share_authentication.directory_type, null) == "AD" &&
        try(var.file_share_authentication.active_directory, null) != null
      )
    )
    error_message = "`file_share_authentication.active_directory` block is required when `file_share_authentication.directory_type` is set to `AD`."
  }
}
