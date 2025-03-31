key_vaults_dev = [
  {
    env                             = "dev"
    tags                            = { "environment" = "dev", "managedBy" = "Terraform" }
    name                            = "lh-kv-drpay-dev"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    kv_admin_objects_ids            = ["82af1c54-5808-4d58-8e38-87526cb6ba29"]
    kv_reader_objects_ids           = ["52fe689b-5ba4-4565-b84c-68d27a61f8d9"]
    kv_secrets_user_objects_ids     = ["52fe689b-5ba4-4565-b84c-68d27a61f8d9"]
    kv_certificate_user_objects_ids = []
    public_network_access_enabled   = true
    network_acls = [
      {
        bypass                     = "AzureServices"
        default_action             = "Deny"
        ip_rules                   = ["66.97.189.250"]
        virtual_network_subnet_ids = []
      }
    ]
    purge_protection_enabled   = true
    soft_delete_retention_days = 7
    rbac_authorization_enabled = true
  },
  {
    env                             = "dev"
    tags                            = { "environment" = "dev", "managedBy" = "Terraform" }
    name                            = "lh-kv-qa-auto-dev"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    kv_admin_objects_ids            = ["9e2ce73e-7890-4e76-a316-fff9d7db0795"]
    kv_reader_objects_ids           = ["d21f7eea-f052-4223-8821-a2607cc8098b"]
    kv_secrets_user_objects_ids     = ["d21f7eea-f052-4223-8821-a2607cc8098b"]
    kv_certificate_user_objects_ids = []
    public_network_access_enabled   = true
    network_acls = [
      {
        bypass                     = "AzureServices"
        default_action             = "Deny"
        ip_rules                   = ["66.97.189.250"]
        virtual_network_subnet_ids = []
      }
    ]
    purge_protection_enabled   = true
    soft_delete_retention_days = 7
    rbac_authorization_enabled = true
  },
  {
    env                             = "dev"
    tags                            = { "environment" = "dev", "managedBy" = "Terraform" }
    name                            = "lh-kv-lhwebsite-dev"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    kv_admin_objects_ids            = ["9a436d42-2ea2-4713-be17-956bd69b479b"]
    kv_reader_objects_ids           = ["b0e1940e-aa06-4b21-9110-7e11a1c4e535"]
    kv_secrets_user_objects_ids     = ["b0e1940e-aa06-4b21-9110-7e11a1c4e535"]
    kv_certificate_user_objects_ids = []
    public_network_access_enabled   = true
    network_acls = [
      {
        bypass                     = "AzureServices"
        default_action             = "Deny"
        ip_rules                   = ["66.97.189.250"]
        virtual_network_subnet_ids = []
      }
    ]
    purge_protection_enabled   = true
    soft_delete_retention_days = 7
    rbac_authorization_enabled = true
  },
  {
    env                             = "dev"
    tags                            = { "environment" = "dev", "managedBy" = "Terraform" }
    name                            = "lh-kv-connect-dev"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    kv_admin_objects_ids            = ["4732e3bc-ff44-4bc9-8c1e-4b368f0fed6d"]
    kv_reader_objects_ids           = ["9455994e-d9cb-4e0c-a6ca-5c1327634d82"]
    kv_secrets_user_objects_ids     = ["9455994e-d9cb-4e0c-a6ca-5c1327634d82"]
    kv_certificate_user_objects_ids = []
    public_network_access_enabled   = true
    network_acls = [
      {
        bypass                     = "AzureServices"
        default_action             = "Deny"
        ip_rules                   = ["66.97.189.250"]
        virtual_network_subnet_ids = []
      }
    ]
    purge_protection_enabled   = true
    soft_delete_retention_days = 7
    rbac_authorization_enabled = true
  },
  {
    env                             = "dev"
    tags                            = { "environment" = "dev", "managedBy" = "Terraform" }
    name                            = "lh-kv-qa-auto-local"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    kv_admin_objects_ids            = ["c0d75f5e-0be8-44ae-bd71-b51f6517d919"]
    kv_reader_objects_ids           = ["162af4f3-fa83-4292-8ebe-414d7cc97f06"]
    kv_secrets_user_objects_ids     = ["162af4f3-fa83-4292-8ebe-414d7cc97f06"]
    kv_certificate_user_objects_ids = []
    public_network_access_enabled   = true
    network_acls = [
      {
        bypass                     = "AzureServices"
        default_action             = "Deny"
        ip_rules                   = ["66.97.189.250"]
        virtual_network_subnet_ids = []
      }
    ]
    purge_protection_enabled   = true
    soft_delete_retention_days = 7
    rbac_authorization_enabled = true
  }
]
