variable "catalog_assets" {
  type = map(object({
    description = optional(string)
    managed_tables = list(object({
      name              = string
      table_description = optional(string)
      columns = list(object({
        name     = string
        type     = string
        nullable = bool
        comment  = optional(string)
      }))
    }))
    volumes = optional(list(object({
      name                   = string
      external_location_name = string
      comment                = optional(string)
      readers                = optional(list(string), [])
      writers                = optional(list(string), [])
    })), [])
    grants = optional(list(object({
      principal  = string
      privileges = list(string)
    })), [])
  }))
  description = "configurations for databricks catalog assets, like managed tables"
}

variable "catalog_grants" {
  type = list(object({
    principal  = string
    privileges = list(string)
  }))
  default     = []
  description = "dynamic grants at the catalog level for specific principals"
}

variable "cluster_id" {
  type        = string
  description = "Compute Cluster ID to use for creating tables. Avoids automatic 'terraform-sql-table'cluster from being created https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/sql_table#cluster_id"
}

variable "env" {
  type        = string
  description = "Environment shortname"
  validation {
    condition = contains([
      "sbox",
      "stg",
      "prod",
      "shared"
    ], lower(var.env))
    error_message = "Invalid value"
  }
}

variable "external_storage_locations" {
  type = list(object({
    external_location_name = string
    storage_account_name   = string
    container_name         = string
    path                   = optional(string, "")
    grants = optional(list(object({
      principal  = string
      privileges = list(string)
    })), [])
  }))
  description = "external storage locations configuration"
}

variable "location" {
  type        = string
  description = "The Azure Region"
}

variable "metastore_id" {
  type        = string
  description = "databricks metastore id"
}

variable "token_usage_permissions" {
  type        = list(string)
  default     = []
  description = "values of service principal identifiers (application_ids) that are to be granted PAT Token usage"
}

variable "subscription_id" {
  type        = string
  description = "subscription id (guid)"
}

variable "unity_catalog_storage_account_name" {
  type        = string
  description = "storage account basename"
}

variable "workspace_id" {
  type        = number
  description = "databricks workspace id"
}
