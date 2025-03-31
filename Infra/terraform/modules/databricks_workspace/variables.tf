variable "cluster_configurations" {
  type = list(object({
    name                    = string
    spark_version           = optional(string, null)
    node_type_id            = optional(string, null)
    autotermination_minutes = number
    max_workers             = number
  }))
  description = "compute cluster configurations"
}

variable "cluster_policies" {
  type = list(object({
    name        = string
    description = string
    definition = object({
      cluster_type = object({
        type  = string
        value = string
      })
      num_workers = optional(object({
        type         = string
        defaultValue = number
        maxValue     = number
        isOptional   = bool
      }))
      node_type_id = optional(object({
        type       = string
        isOptional = bool
      }))
      spark_version = optional(object({
        type   = string
        hidden = bool
      }))
    })
  }))
  description = "compute cluster policies"
}

variable "dashboards" {
  type = list(object({
    name = string
    grants = optional(list(object({
      group_name       = string
      permission_level = string
    })), [])
  }))
  default     = []
  description = "Published dashboard configurations"
}

variable "dlt_pipelines" {
  type = list(object({
    name          = string
    target        = string
    continuous    = bool
    development   = bool
    photon        = bool
    channel       = string
    edition       = string
    notebooks     = list(string)
    configuration = optional(map(string))
    cluster = object({
      policy              = string
      num_workers         = optional(number, 1)
      node_type_id        = optional(string)
      driver_node_type_id = optional(string)
    })
  }))
  description = "Delta Live Table Pipeline configurations"
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

variable "job_configurations" {
  type = list(object({
    name        = string
    description = string
    tasks = map(object({
      existing_cluster_name = optional(string)
      pipeline_task = optional(object({
        pipeline_name = string
      }))
      notebook_task = optional(object({
        notebook_name = string
      }))
      dependencies = optional(list(string), [])
    }))
    schedule = optional(object({
      quartz_cron_expression = string
      timezone_id            = string
    }))
  }))
  description = "Databricks job configurations"
}

variable "key_vault_id" {
  type        = string
  description = "ID for keyvault to create secret scope"
}

variable "key_vault_uri" {
  type        = string
  description = "DNS for keyvault used for secret scope"
}

variable "sql_endpoints" {
  type = list(object({
    name             = string
    cluster_size     = string
    min_num_clusters = number
    max_num_clusters = number
    auto_stop_mins   = number
    warehouse_type   = string
    grants = optional(list(object({
      group_name             = optional(string)
      service_principal_name = optional(string)
      permission_level       = string
    })), [])
  }))
  default     = []
  description = "sql endpoint configurations"
  validation {
    condition = alltrue([
      for endpoint in var.sql_endpoints : alltrue([
        for grant in endpoint.grants : (
          (grant.group_name != null ? 1 : 0) +
          (grant.service_principal_name != null ? 1 : 0) == 1
        )
      ])
    ])
    error_message = "Exactly one of 'group_name' or 'service_principal_name' must be specified for each grant."
  }
}

variable "subscription_id" {
  type        = string
  description = "subscription id (guid)"
}

variable "tenant_id" {
  type        = string
  description = "azure tentant id"
}

variable "workspace_id" {
  type        = string
  description = "databricks workspace id"
}
