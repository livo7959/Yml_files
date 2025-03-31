inputs = {
  resource_groups = {
    data = {
      location = "eastus",
      resources = {
        container_apps = [
          {
            name          = "data-fetcher",
            registry_name = "lhacr",
            target_port   = 8080
            containers = [
              {
                container_name = "data-fetcher",
                image_name     = "data-fetcher",
                cpu_core       = 0.25,
                memory_size    = "0.5Gi"
              }
            ]
          }
        ],
        container_registries = [
          {
            name = "lhacr",
            sku  = "Premium"
          }
        ],
        data_factories = [
          {
            name = "logix-data",
            integration_runtimes = [
              "DataIntegrationRuntime"
            ],
            linked_services = {
              adls2 = [
                {
                  name                 = "LogixDataLakeStorage",
                  storage_account_name = "lhdatalakestorage"
                }
              ],
              key_vault = [
                {
                  name           = "LogixDataAzureKeyVault",
                  key_vault_name = "lh-azkv"
                }
              ],
              sql_server = {
                sbox = [
                  {
                    name                                    = "AdfDevDB",
                    integration_runtime_name                = "DataIntegrationRuntime",
                    connection_string_key_vault_ref_name    = "LogixDataAzureKeyVault",
                    connection_string_key_vault_secret_name = "adf-dev-db-connection-string",
                    password_key_vault_ref_name             = "LogixDataAzureKeyVault",
                    password_key_vault_secret_name          = "adf-dev-db-pw"
                  }
                ]
                stg = [
                  {
                    name                                    = "AllScriptsNtierSecurity",
                    integration_runtime_name                = "DataIntegrationRuntime",
                    connection_string_key_vault_ref_name    = "LogixDataAzureKeyVault",
                    connection_string_key_vault_secret_name = "allscripts-ntier-tumg-connection-string",
                    username                                = "corp\\svc_sqlpm_db",
                    password_key_vault_ref_name             = "LogixDataAzureKeyVault",
                    password_key_vault_secret_name          = "allscripts-svc-sqlpm-db-pw"
                  },
                  {
                    name                                    = "BEDPSQLSI02_LogixCodify",
                    integration_runtime_name                = "DataIntegrationRuntime",
                    connection_string_key_vault_ref_name    = "LogixDataAzureKeyVault",
                    connection_string_key_vault_secret_name = "adf-bedpsqlsi02-db-connection-string",
                    username                                = "corp\\SVC_SI02_codify_read",
                    password_key_vault_ref_name             = "LogixDataAzureKeyVault",
                    password_key_vault_secret_name          = "adf-bedpsqlsi02-db-pw"
                  },
                  {
                    name                                    = "BEDSQLRPT002_LogixDW",
                    integration_runtime_name                = "DataIntegrationRuntime",
                    connection_string_key_vault_ref_name    = "LogixDataAzureKeyVault",
                    connection_string_key_vault_secret_name = "adf-bedsqlrpt002-logixdw-connection-string",
                    username                                = "corp\\svc_adf_LogixDW",
                    password_key_vault_ref_name             = "LogixDataAzureKeyVault",
                    password_key_vault_secret_name          = "adf-bedsqlrpt002-logixdw-pw"
                  },
                  {
                    name                                    = "BEDSQLRPT002_Reporting_Imports",
                    integration_runtime_name                = "DataIntegrationRuntime",
                    connection_string_key_vault_ref_name    = "LogixDataAzureKeyVault",
                    connection_string_key_vault_secret_name = "adf-bedsqlrpt002-reportingimports-connection-string",
                    username                                = "corp\\svc_adf_RprtImports",
                    password_key_vault_ref_name             = "LogixDataAzureKeyVault",
                    password_key_vault_secret_name          = "adf-bedsqlrpt002-reportingimports-pw"
                  }
                ]
                prod = []
              }
            },
            datasets = {
              delimited_text = {
                sbox = [
                  {
                    name                = "adls2_csv"
                    linked_service_name = "LogixDataLakeStorage"
                    parameters = {
                      storage_container_name = ""
                      schema_name            = ""
                      table_name             = ""
                    }
                    storage_container = "@{dataset().storage_container_name}"
                    storage_path      = "@{pipeline().Pipeline}/@{dataset().schema_name}/@{dataset().table_name}"
                    storage_filename  = "@{utcNow('yyyy-MM-ddTHH_mm_ss_fffffffK')}_@{pipeline().RunId}.csv"
                  }
                ]
                stg = [
                  {
                    name                = "adls2_csv"
                    linked_service_name = "LogixDataLakeStorage"
                    parameters = {
                      storage_container_name = ""
                      schema_name            = ""
                      table_name             = ""
                    }
                    storage_container = "@{dataset().storage_container_name}"
                    storage_path      = "@{pipeline().Pipeline}/@{dataset().schema_name}/@{dataset().table_name}"
                    storage_filename  = "@{utcNow('yyyy-MM-ddTHH_mm_ss_fffffffK')}_@{pipeline().RunId}.csv"
                  }
                ]
              }
              parquet = {
                sbox = [
                  {
                    name                = "adls2_parquet"
                    linked_service_name = "LogixDataLakeStorage"
                    parameters = {
                      storage_container_name = ""
                      schema_name            = ""
                      table_name             = ""
                    }
                    storage_container = "@{dataset().storage_container_name}"
                    storage_path      = "@{pipeline().Pipeline}/@{dataset().schema_name}/@{dataset().table_name}"
                    storage_filename  = "@{utcNow('yyyy-MM-ddTHH_mm_ss_fffffffK')}_@{pipeline().RunId}.parquet"
                  }
                ]
                stg = [
                  {
                    name                = "adls2_parquet"
                    linked_service_name = "LogixDataLakeStorage"
                    parameters = {
                      storage_container_name = ""
                      schema_name            = ""
                      table_name             = ""
                    }
                    storage_container = "@{dataset().storage_container_name}"
                    storage_path      = "@{pipeline().Pipeline}/@{dataset().schema_name}/@{dataset().table_name}"
                    storage_filename  = "@{utcNow('yyyy-MM-ddTHH_mm_ss_fffffffK')}_@{pipeline().RunId}.parquet"
                  }
                ]
              }
              sql_server_table = {
                sbox = [
                  {
                    name                = "adf_dev_db"
                    linked_service_name = "AdfDevDB"
                    parameters = {
                      schema_name = ""
                      table_name  = ""
                    }
                    table_name = "@{dataset().schema_name}.@{dataset().table_name}"
                  }
                ]
                stg = [
                  {
                    name                = "BEDSQLRPT002_LogixDW"
                    linked_service_name = "BEDSQLRPT002_LogixDW"
                    parameters = {
                      schema_name = ""
                      table_name  = ""
                    }
                    table_name = "@{dataset().schema_name}.@{dataset().table_name}"
                  },
                  {
                    name                = "BEDSQLRPT002_Reporting_Imports"
                    linked_service_name = "BEDSQLRPT002_Reporting_Imports"
                    parameters = {
                      schema_name = ""
                      table_name  = ""
                    }
                    table_name = "@{dataset().schema_name}.@{dataset().table_name}"
                  },
                  {
                    name                = "BEDPSQLSI02_LogixCodify"
                    linked_service_name = "BEDPSQLSI02_LogixCodify"
                    parameters = {
                      schema_name = ""
                      table_name  = ""
                    }
                    table_name = "@{dataset().schema_name}.@{dataset().table_name}"
                  }
                ]
              }
            }
            pipelines = {
              sbox = [
                {
                  name = "sql_server_to_adls2"
                  parameters = {
                    schema_name = ""
                    table_name  = ""
                  }
                  activities = [
                    {
                      name      = "Copy data to ADLS2",
                      type      = "Copy",
                      dependsOn = [],
                      policy = {
                        timeout                = "0.12:00:00",
                        retry                  = 0,
                        retryIntervalInSeconds = 30,
                        secureOutput           = false,
                        secureInput            = false
                      },
                      userProperties = [],
                      typeProperties = {
                        source = {
                          type            = "SqlServerSource",
                          queryTimeout    = "02:00:00",
                          partitionOption = "None"
                        },
                        sink = {
                          type = "DelimitedTextSink",
                          storeSettings = {
                            type = "AzureBlobFSWriteSettings"
                          },
                          formatSettings = {
                            type          = "DelimitedTextWriteSettings",
                            quoteAllText  = true,
                            fileExtension = ".csv"
                          }
                        },
                        enableStaging = false,
                        translator = {
                          type           = "TabularTranslator",
                          typeConversion = true,
                          typeConversionSettings = {
                            allowDataTruncation  = true,
                            treatBooleanAsNumber = false
                          }
                        }
                      },
                      inputs = [
                        {
                          referenceName = "adf_dev_db",
                          type          = "DatasetReference"
                          parameters = {
                            schema_name = "@{pipeline().parameters.schema_name}",
                            table_name  = "@{pipeline().parameters.table_name}"
                          }
                        }
                      ],
                      outputs = [
                        {
                          referenceName = "adls2_csv",
                          type          = "DatasetReference",
                          parameters = {
                            storage_container_name = "cdc-beddsqlrpt001"
                            schema_name            = "@{pipeline().parameters.schema_name}",
                            table_name             = "@{pipeline().parameters.table_name}"
                          }
                        }
                      ]
                    }
                  ]
                }
              ],
              stg = [
                {
                  name = "BEDSQLRPT002_LogixDW_to_adls2"
                  parameters = {
                    schema_name = ""
                    table_name  = ""
                  }
                  activities = [
                    {
                      name      = "Copy data to ADLS2",
                      type      = "Copy",
                      dependsOn = [],
                      policy = {
                        timeout                = "0.12:00:00",
                        retry                  = 0,
                        retryIntervalInSeconds = 30,
                        secureOutput           = false,
                        secureInput            = false
                      },
                      userProperties = [],
                      typeProperties = {
                        source = {
                          type            = "SqlServerSource",
                          queryTimeout    = "02:00:00",
                          partitionOption = "None"
                        },
                        sink = {
                          type = "ParquetSink",
                          storeSettings = {
                            type         = "AzureBlobFSWriteSettings",
                            copyBehavior = "PreserveHierarchy"
                          },
                          formatSettings = {
                            type = "ParquetWriteSettings"
                          }
                        },
                        enableStaging = false,
                        translator = {
                          type           = "TabularTranslator",
                          typeConversion = true,
                          typeConversionSettings = {
                            allowDataTruncation  = true,
                            treatBooleanAsNumber = false
                          }
                        }
                      },
                      inputs = [
                        {
                          referenceName = "BEDSQLRPT002_LogixDW",
                          type          = "DatasetReference"
                          parameters = {
                            schema_name = "@{pipeline().parameters.schema_name}",
                            table_name  = "@{pipeline().parameters.table_name}"
                          }
                        }
                      ],
                      outputs = [
                        {
                          referenceName = "adls2_parquet",
                          type          = "DatasetReference",
                          parameters = {
                            storage_container_name = "cdc-on-prem",
                            schema_name            = "@{pipeline().parameters.schema_name}",
                            table_name             = "@{pipeline().parameters.table_name}"
                          }
                        }
                      ]
                    }
                  ]
                },
                {
                  name = "BEDSQLRPT002_Reporting_Imports_to_adls2"
                  parameters = {
                    schema_name = ""
                    table_name  = ""
                  }
                  activities = [
                    {
                      name      = "Copy data to ADLS2",
                      type      = "Copy",
                      dependsOn = [],
                      policy = {
                        timeout                = "0.12:00:00",
                        retry                  = 0,
                        retryIntervalInSeconds = 30,
                        secureOutput           = false,
                        secureInput            = false
                      },
                      userProperties = [],
                      typeProperties = {
                        source = {
                          type            = "SqlServerSource",
                          queryTimeout    = "02:00:00",
                          partitionOption = "None"
                        },
                        sink = {
                          type = "ParquetSink",
                          storeSettings = {
                            type         = "AzureBlobFSWriteSettings",
                            copyBehavior = "PreserveHierarchy"
                          },
                          formatSettings = {
                            type = "ParquetWriteSettings"
                          }
                        },
                        enableStaging = false,
                        translator = {
                          type           = "TabularTranslator",
                          typeConversion = true,
                          typeConversionSettings = {
                            allowDataTruncation  = true,
                            treatBooleanAsNumber = false
                          }
                        }
                      },
                      inputs = [
                        {
                          referenceName = "BEDSQLRPT002_Reporting_Imports",
                          type          = "DatasetReference"
                          parameters = {
                            schema_name = "@{pipeline().parameters.schema_name}",
                            table_name  = "@{pipeline().parameters.table_name}"
                          }
                        }
                      ],
                      outputs = [
                        {
                          referenceName = "adls2_parquet",
                          type          = "DatasetReference",
                          parameters = {
                            storage_container_name = "cdc-on-prem",
                            schema_name            = "@{pipeline().parameters.schema_name}",
                            table_name             = "@{pipeline().parameters.table_name}"
                          }
                        }
                      ]
                    }
                  ]
                },
                {
                  name = "BEDPSQLSI02_LogixCodify_to_adls2"
                  parameters = {
                    schema_name = ""
                    table_name  = ""
                  }
                  activities = [
                    {
                      name      = "Copy data from BEDPSQLSI02_LogixCodify to ADLS2",
                      type      = "Copy",
                      dependsOn = [],
                      policy = {
                        timeout                = "0.12:00:00",
                        retry                  = 0,
                        retryIntervalInSeconds = 30,
                        secureOutput           = false,
                        secureInput            = false
                      },
                      userProperties = [],
                      typeProperties = {
                        source = {
                          type            = "SqlServerSource",
                          queryTimeout    = "02:00:00",
                          partitionOption = "None"
                        },
                        sink = {
                          type = "ParquetSink",
                          storeSettings = {
                            type         = "AzureBlobFSWriteSettings",
                            copyBehavior = "PreserveHierarchy"
                          },
                          formatSettings = {
                            type = "ParquetWriteSettings"
                          }
                        },
                        enableStaging = false,
                        translator = {
                          type           = "TabularTranslator",
                          typeConversion = true,
                          typeConversionSettings = {
                            allowDataTruncation  = true,
                            treatBooleanAsNumber = false
                          }
                        }
                      },
                      inputs = [
                        {
                          referenceName = "BEDPSQLSI02_LogixCodify",
                          type          = "DatasetReference"
                          parameters = {
                            schema_name = "@{pipeline().parameters.schema_name}",
                            table_name  = "@{pipeline().parameters.table_name}"
                          }
                        }
                      ],
                      outputs = [
                        {
                          referenceName = "adls2_parquet",
                          type          = "DatasetReference",
                          parameters = {
                            storage_container_name = "cdc-on-prem",
                            schema_name            = "@{pipeline().parameters.schema_name}",
                            table_name             = "@{pipeline().parameters.table_name}"
                          }
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          }
        ],
        key_vaults = {
          lh-azkv = {
            keys = [
              {
                key_name = "epic-fhir"
                key_type = "RSA"
                key_size = 2048
                key_opts = [
                  "decrypt",
                  "encrypt",
                  "sign",
                  "unwrapKey",
                  "verify",
                  "wrapKey"
                ]
              },
              {
                key_name = "epic-fhir-ec384"
                key_type = "EC"
                curve    = "P-384"
                key_opts = [
                  "sign",
                  "verify"
                ]
              }
            ]
          }
        },
        role_definitions = [
          {
            name        = "storage_list_keys"
            description = "List files in Storage Accounts"
            actions = [
              "Microsoft.Storage/storageAccounts/listKeys/action"
            ]
          }
        ],
        service_bus = {
          lh-data = {
            queues = [
              {
                name = "data-fetcher"
              }
            ]
            subscriptions = [
              {
                name               = "external-file-fetch"
                topic_name         = "external-file-fetch"
                max_delivery_count = 1
              }
            ]
            topics = [
              {
                name = "external-file-fetch"
              }
            ]
          }
        }
        storage_accounts = [
          {
            name                          = "lhdatalakestorage",
            account_tier                  = "Standard",
            account_replication_type      = "GRS",
            account_kind                  = "StorageV2",
            access_tier                   = "Hot",
            public_network_access_enabled = true,
            sftp_enabled                  = true,
            hns_enabled                   = true,
            containers = [
              {
                name = "cdc-beddsqlrpt001"
              },
              {
                name = "cdc-on-prem"
              },
              {
                name = "globalscape-eft"
              },
              {
                name = "public-data"
              },
              {
                name = "raw-fhir"
              },
              {
                name = "symplr"
              },
              {
                name = "uploaded-data"
              }
            ],
            vnet_access = [
              {
                resource_group_name = "rg-databricks"
                virtual_network     = "vnet-databricks-eus"
                subnet              = "snet-databricks-public-eus"
              }
            ]
          },
          {
            name                          = "lhexternalsftp",
            account_tier                  = "Standard",
            account_replication_type      = "LRS",
            account_kind                  = "StorageV2",
            access_tier                   = "Hot",
            public_network_access_enabled = true,
            sftp_enabled                  = false,
            hns_enabled                   = true,
            containers = [
              {
                name = "client1"
              },
              {
                name = "melrosewakefield"
              },
              {
                name = "lhintegratorcutover"
              }
            ]
          },
          {
            name                          = "lhunitycatmanaged",
            account_tier                  = "Standard",
            account_replication_type      = "GRS",
            account_kind                  = "StorageV2",
            access_tier                   = "Hot",
            public_network_access_enabled = true,
            sftp_enabled                  = false,
            hns_enabled                   = true,
            containers = [
              {
                name = "bronze"
              },
              {
                name = "gold"
              },
              {
                name = "silver"
              },
              {
                name = "datalake"
              }
            ],
            vnet_access = [
              {
                resource_group_name = "rg-databricks"
                virtual_network     = "vnet-databricks-eus"
                subnet              = "snet-databricks-public-eus"
              }
            ]
          }
        ]
      }
    }
  }
}
