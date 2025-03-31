variable "env" {
  type        = string
  description = "Environment shortname"
  validation {
    condition = contains([
      "sbox",
      "stg",
      "prod",
      "shared",
      "ostg",
      "oprd"
    ], lower(var.env))
    error_message = "Invalid value"
  }
}

variable "resource_groups" {
  type = map(object({
    location = string
    resources = object({
      cdn_profiles = optional(list(object({
        name = string
        endpoint_configs = list(object({
          name          = string
          origin_name   = string
          origin_path   = optional(string)
          host_name     = string
          custom_domain = optional(string)
        }))
      })), [])
      container_apps = optional(list(object({
        name          = string
        registry_name = string
        target_port   = number
        containers = list(object({
          container_name = string
          image_name     = string
          cpu_core       = number
          memory_size    = string
        }))
        domains = optional(list(object({
          name         = string
          binding_type = string
        })), [])
      })), [])
      container_registries = optional(list(object({
        name = string
        sku  = string
      })), [])
      databricks_workspaces = optional(list(object({
        name = string
        sku  = string
        network = object({
          virtual_network = string
          public_subnet   = string
          private_subnet  = string
        })
        private_endpoints = optional(list(object({
          name = string
          private_link_service_connection = object({
            name              = string
            subresource_names = list(string)
          })
          private_dns_zone_name = optional(string, null)
          vnet                  = string
          subnet                = string
        })), [])
        access_connector_permissions = optional(object({
          service_bus = optional(list(object({
            name                = string
            resource_group_name = string
            role                = string
          })), [])
        }), {})
      })), [])
      data_factories = optional(list(object({
        name                 = string
        integration_runtimes = optional(list(string), [])
        linked_services = object({
          adls2 = optional(list(object({
            name                 = string
            storage_account_name = string
          })), [])
          az_databricks = optional(list(object({
            name                       = string
            adb_domain                 = string
            msi_work_space_resource_id = string
          })), [])
          az_datalake = optional(map(list(object({
            name                             = string
            adb_domain                       = string
            databricks_workspace_resource_id = string
            cluster_id                       = string
          }))), {})
          key_vault = optional(list(object({
            name           = string
            key_vault_name = string
          })), [])
          sql_server = map(list(object({
            name                                    = string
            integration_runtime_name                = string
            connection_string_key_vault_ref_name    = string
            connection_string_key_vault_secret_name = string
            username                                = optional(string, null)
            password_key_vault_ref_name             = string
            password_key_vault_secret_name          = string
          })))
        })
        datasets = object({
          delimited_text = map(list(object({
            name                = string
            linked_service_name = string
            parameters          = optional(map(string), {})
            storage_container   = string
            storage_path        = string
            storage_filename    = string
          })))
          parquet = map(list(object({
            name                = string
            linked_service_name = string
            parameters          = optional(map(string), {})
            storage_container   = string
            storage_path        = string
            storage_filename    = string
          })))
          sql_server_table = map(list(object({
            name                = string
            linked_service_name = string
            parameters          = optional(map(string), {})
            table_name          = string
          })))
        })
        pipelines = map(list(object({
          name       = string
          parameters = optional(map(string), {})
          variables  = optional(map(string), {})
          activities = list(object({
            name      = string
            type      = string
            dependsOn = optional(list(string), [])
            policy = object({
              timeout                = string
              retry                  = number
              retryIntervalInSeconds = number
              secureOutput           = bool
              secureInput            = bool
            })
            userProperties = optional(list(string), [])
            typeProperties = object({
              source = object({
                type            = string
                queryTimeout    = string
                partitionOption = string
              })
              sink = object({
                type           = string
                storeSettings  = map(string)
                formatSettings = map(any)
              })
              enableStaging = bool
              translator = object({
                type           = string
                typeConversion = bool
                typeConversionSettings = object({
                  allowDataTruncation  = bool
                  treatBooleanAsNumber = bool
                })
              })
            })
            inputs = list(object({
              referenceName = string
              type          = string
              parameters    = map(string)
            }))
            outputs = list(object({
              referenceName = string
              type          = string
              parameters    = map(string)
            }))
          }))
        })))
      })), [])
      key_vaults = optional(map(object({
        keys = optional(list(object({
          key_name = string
          key_type = string
          key_size = optional(number)
          curve    = optional(string)
          key_opts = list(string)
        })), [])
      })), {})
      nat_gateways = optional(list(string), [])
      network_security_groups = optional(list(object({
        name = string
        security_rules = list(object({
          name                       = string
          access                     = string
          description                = string
          destination_address_prefix = string
          destination_port_range     = string
          direction                  = string
          priority                   = number
          protocol                   = string
          source_address_prefix      = string
          source_port_range          = string
        }))
      })), [])
      private_dns_zones = optional(list(string), [])
      private_endpoints = optional(list(object({
        name = string
        private_link_service_connection = object({
          name              = string
          subresource_names = list(string)
        })
        private_dns_zone_name = optional(string, null)
        vnet                  = string
        subnet                = string
      })), [])
      role_definitions = optional(list(object({
        name             = string
        description      = string
        actions          = optional(list(string), [])
        data_actions     = optional(list(string), [])
        not_actions      = optional(list(string), [])
        not_data_actions = optional(list(string), [])
      })), [])
      service_bus = optional(map(object({
        queues = optional(list(object({
          name = string
        })), [])
        subscriptions = optional(list(object({
          name               = string
          topic_name         = string
          max_delivery_count = number
        })), [])
        topics = optional(list(object({
          name = string
        })), [])
      })), {})
      storage_accounts = optional(list(object({
        name                            = string
        account_kind                    = string
        account_tier                    = string
        account_replication_type        = string
        access_tier                     = optional(string, null)
        allow_nested_items_to_be_public = optional(bool, false)
        public_network_access_enabled   = bool
        public_network_access_vnet_ip   = optional(bool, true)
        sftp_enabled                    = bool
        hns_enabled                     = bool
        bypass                          = optional(set(string), ["AzureServices"])
        vnet_access = optional(list(object({
          subscription_id     = optional(string)
          resource_group_name = optional(string)
          virtual_network     = string
          subnet              = string
        })), [])
        containers = optional(list(object({
          name                  = string
          container_access_type = optional(string, "private")
        })), [])
        cors_rule = optional(list(object({
          allowed_origins    = list(string)
          allowed_methods    = list(string)
          allowed_headers    = list(string)
          exposed_headers    = list(string)
          max_age_in_seconds = number
        })), [])
        private_link_access = optional(list(string), [])
      })), [])
      virtual_networks = optional(list(object({
        name          = string
        address_space = map(list(string))
        subnets = optional(list(object({
          name                   = string
          address_prefixes       = map(string)
          network_security_group = optional(string)
          delegation = optional(list(object({
            name = string
            actions = optional(list(string), [
              "Microsoft.Network/virtualNetworks/subnets/join/action",
              "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
              "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
            ])
          })), [])
          service_endpoints                 = optional(list(string), [])
          nat_gateway                       = optional(string, "")
          private_endpoint_network_policies = optional(string, null)
        })), [])
        dns_servers       = optional(list(string), [])
        private_dns_zones = optional(list(string), [])
      })), [])
    })
  }))
  description = "Configuration of Resource Groups"
}

variable "subscription_id" {
  type        = string
  description = "subscription id (guid)"
}
