include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_terragrunt_dir()}/../../../modules//main"
}

inputs = {
  resource_groups = {
    databricks = {
      location = "eastus",
      resources = {
        databricks_workspaces = [
          {
            name = "web-auth-eus",
            sku  = "premium",
            network = {
              virtual_network = "databricks",
              public_subnet   = "databricks-public",
              private_subnet  = "databricks-private"
            }
          }
        ],
        network_security_groups = [
          {
            name = "databricks",
            security_rules = [
              {
                name                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-inbound",
                access                     = "Allow",
                description                = "Required for worker nodes communication within a cluster.",
                destination_address_prefix = "VirtualNetwork",
                destination_port_range     = "*",
                direction                  = "Inbound",
                priority                   = 100,
                protocol                   = "*",
                source_address_prefix      = "VirtualNetwork",
                source_port_range          = "*"
              },
              {
                name                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-databricks-webapp",
                access                     = "Allow",
                description                = "Required for workers communication with Databricks Webapp.",
                destination_address_prefix = "AzureDatabricks",
                destination_port_range     = "443",
                direction                  = "Outbound",
                priority                   = 102,
                protocol                   = "Tcp",
                source_address_prefix      = "VirtualNetwork",
                source_port_range          = "*"
              },
              {
                name                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-sql",
                access                     = "Allow",
                description                = "Required for workers communication with Azure SQL services.",
                destination_address_prefix = "Sql",
                destination_port_range     = "3306",
                direction                  = "Outbound",
                priority                   = 100,
                protocol                   = "Tcp",
                source_address_prefix      = "VirtualNetwork",
                source_port_range          = "*"
              },
              {
                name                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-storage",
                access                     = "Allow",
                description                = "Required for workers communication with Azure Storage services.",
                destination_address_prefix = "Storage",
                destination_port_range     = "443",
                direction                  = "Outbound",
                priority                   = 101,
                protocol                   = "Tcp",
                source_address_prefix      = "VirtualNetwork",
                source_port_range          = "*"
              },
              {
                name                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-outbound",
                access                     = "Allow",
                description                = "Required for worker nodes communication within a cluster.",
                destination_address_prefix = "VirtualNetwork",
                destination_port_range     = "*",
                direction                  = "Outbound",
                priority                   = 103,
                protocol                   = "*",
                source_address_prefix      = "VirtualNetwork",
                source_port_range          = "*"
              },
              {
                name                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-eventhub",
                access                     = "Allow",
                description                = "Required for worker communication with Azure Eventhub services.",
                destination_address_prefix = "EventHub",
                destination_port_range     = "9093",
                direction                  = "Outbound",
                priority                   = 104,
                protocol                   = "Tcp",
                source_address_prefix      = "VirtualNetwork",
                source_port_range          = "*"
              }
            ]
          }
        ],
        storage_accounts = [
          {
            name                          = "unitycatalogeus",
            account_tier                  = "Premium",
            account_replication_type      = "ZRS",
            account_kind                  = "BlockBlobStorage",
            public_network_access_enabled = true, // enabled as true to correctly apply custom vnet and ip allow rules. Setting this to false does not allow us to apply these rules.
            sftp_enabled                  = false,
            hns_enabled                   = true,
            bypass                        = ["None"],
            containers = [
              {
                name = "metastore"
              }
            ],
            vnet_access = [
              {
                virtual_network = "vnet-databricks-eus"
                subnet          = "snet-databricks-private-eus"
              },
              {
                virtual_network = "vnet-databricks-eus"
                subnet          = "snet-databricks-public-eus"
              },
              {
                subscription_id     = "8192a5d8-1a56-4caf-b961-0eae16cbd1d3"
                resource_group_name = "rg-databricks-sbox"
                virtual_network     = "vnet-databricks-eus-sbox"
                subnet              = "snet-databricks-private-eus-sbox"
              },
              {
                subscription_id     = "8192a5d8-1a56-4caf-b961-0eae16cbd1d3"
                resource_group_name = "rg-databricks-sbox"
                virtual_network     = "vnet-databricks-eus-sbox"
                subnet              = "snet-databricks-public-eus-sbox"
              },
              {
                subscription_id     = "bf6bb924-c903-43e9-9e06-2c2d2c605d1a"
                resource_group_name = "rg-databricks-stg"
                virtual_network     = "vnet-databricks-eus-stg"
                subnet              = "snet-databricks-private-eus-stg"
              },
              {
                subscription_id     = "bf6bb924-c903-43e9-9e06-2c2d2c605d1a"
                resource_group_name = "rg-databricks-stg"
                virtual_network     = "vnet-databricks-eus-stg"
                subnet              = "snet-databricks-public-eus-stg"
              },
              {
                subscription_id     = "f533a95b-ce94-4023-a472-ab4c3748b37c"
                resource_group_name = "rg-databricks-prod"
                virtual_network     = "vnet-databricks-eus-prod"
                subnet              = "snet-databricks-private-eus-prod"
              },
              {
                subscription_id     = "f533a95b-ce94-4023-a472-ab4c3748b37c"
                resource_group_name = "rg-databricks-prod"
                virtual_network     = "vnet-databricks-eus-prod"
                subnet              = "snet-databricks-public-eus-prod"
              }
            ],
            private_link_access = [
              "/subscriptions/*/resourcegroups/*/providers/Microsoft.Databricks/accessConnectors/*"
            ],
            cors_rule = [
              {
                allowed_origins    = ["https://*.azuredatabricks.net"]
                allowed_methods    = ["PUT"]
                allowed_headers    = ["x-ms-blob-type"]
                exposed_headers    = [""] // requires 1 item https://github.com/hashicorp/terraform-provider-azurerm/issues/10936
                max_age_in_seconds = 1800
              }
            ]
          }
        ],
        virtual_networks = [
          {
            name = "databricks",
            subnets = [
              {
                name = "databricks-public",
                address_prefixes = {
                  shared = "10.120.25.0/26"
                },
                network_security_group = "databricks",
                delegation = [
                  {
                    name = "Microsoft.Databricks/workspaces"
                  }
                ],
                service_endpoints = [
                  "Microsoft.KeyVault",
                  "Microsoft.Storage"
                ]
              },
              {
                name = "databricks-private",
                address_prefixes = {
                  shared = "10.120.25.64/26"
                },
                network_security_group = "databricks",
                delegation = [
                  {
                    name = "Microsoft.Databricks/workspaces"
                  }
                ],
                service_endpoints = [
                  "Microsoft.Storage"
                ]
              }
            ],
            address_space = {
              shared = [
                "10.120.25.0/24"
              ]
            },
            dns_servers       = [],
            private_dns_zones = []
          }
        ]
      }
    }
  }
}
