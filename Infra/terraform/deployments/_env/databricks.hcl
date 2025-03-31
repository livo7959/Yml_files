inputs = {
  resource_groups = {
    databricks = {
      location = "eastus",
      resources = {
        virtual_networks = [
          {
            name = "databricks",
            subnets = [
              {
                name = "databricks-public",
                address_prefixes = {
                  sbox = "10.120.170.0/26",
                  stg  = "10.120.172.0/26",
                  prod = "10.120.72.0/25"
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
                ],
                nat_gateway = "databricks"
              },
              {
                name = "databricks-private",
                address_prefixes = {
                  sbox = "10.120.170.128/26",
                  stg  = "10.120.172.128/26",
                  prod = "10.120.73.0/25"
                },
                network_security_group = "databricks",
                delegation = [
                  {
                    name = "Microsoft.Databricks/workspaces"
                  }
                ],
                service_endpoints = [
                  "Microsoft.Storage"
                ],
                nat_gateway = "databricks"
              },
              {
                name = "databricks-private-link",
                address_prefixes = {
                  sbox = "10.120.170.192/26",
                  stg  = "10.120.172.192/26",
                  prod = "10.120.73.192/26"
                },
                private_endpoint_network_policies = "Disabled"
              }
            ],
            address_space = {
              sbox = [
                "10.120.170.0/24"
              ],
              stg = [
                "10.120.172.0/24"
              ],
              prod = [
                "10.120.72.0/23"
              ]
            },
            dns_servers = [],
            private_dns_zones = [
              "privatelink.azuredatabricks.net"
            ]
          }
        ],
        nat_gateways = [
          "databricks"
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
        databricks_workspaces = [
          {
            name = "logix-data",
            sku  = "premium",
            network = {
              virtual_network = "databricks",
              public_subnet   = "databricks-public",
              private_subnet  = "databricks-private"
            },
            private_endpoints = [
              {
                name = "logix-data-be",
                private_link_service_connection = {
                  name = "databricks-backend",
                  subresource_names = [
                    "databricks_ui_api"
                  ]
                },
                private_dns_zone_name = "privatelink.azuredatabricks.net",
                vnet                  = "databricks",
                subnet                = "databricks-private-link"
              }
            ],
            access_connector_permissions = {
              service_bus = [
                {
                  name                = "lh-data"
                  resource_group_name = "data"
                  role                = "Azure Service Bus Data Owner"
                }
              ]
            }
          }
        ],
        private_dns_zones = [
          "privatelink.azuredatabricks.net"
        ]
      }
    }
  }
}
