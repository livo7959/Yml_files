key_vaults_prod = [
  {
    env                             = "prod"
    tags                            = { "environment" = "prod", "managedBy" = "Terraform" }
    name                            = "lh-kv-tab-demo-prod"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    kv_admin_objects_ids            = ["cd517bcc-12f5-4dea-add7-da2a73cab4b8"]
    kv_reader_objects_ids           = ["422a0cbe-41af-486e-8683-86f41aa71d9c"]
    kv_secrets_user_objects_ids     = ["422a0cbe-41af-486e-8683-86f41aa71d9c"]
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
    env                             = "prod"
    tags                            = { "environment" = "prod", "managedBy" = "Terraform" }
    name                            = "lh-kv-tab-express-prod"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    kv_admin_objects_ids            = ["7af2cfe3-0a52-47e0-96c4-a86dbdb23764"]
    kv_reader_objects_ids           = ["8f91d6c6-f19d-48b4-b883-bc39f96e877b"]
    kv_secrets_user_objects_ids     = ["8f91d6c6-f19d-48b4-b883-bc39f96e877b"]
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
    env                             = "prod"
    tags                            = { "environment" = "prod", "managedBy" = "Terraform" }
    name                            = "lh-kv-tab-reporting-prod"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    kv_admin_objects_ids            = ["0f2443b1-2762-4dd5-9950-65544ffc3c4e"]
    kv_reader_objects_ids           = ["be7d1d17-1410-4fee-9633-fec9c2e2e4b3"]
    kv_secrets_user_objects_ids     = ["be7d1d17-1410-4fee-9633-fec9c2e2e4b3"]
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
    env                             = "prod"
    tags                            = { "environment" = "prod", "managedBy" = "Terraform" }
    name                            = "lh-kv-tab-feedback-prod"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    kv_admin_objects_ids            = ["1e4e204d-ed64-4688-8b8e-9153c8be4836"]
    kv_reader_objects_ids           = ["a9fe9783-2b46-4de5-9ebc-48ef8cd086ee"]
    kv_secrets_user_objects_ids     = ["a9fe9783-2b46-4de5-9ebc-48ef8cd086ee"]
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
    env                             = "uat"
    tags                            = { "environment" = "uat", "managedBy" = "Terraform" }
    name                            = "lh-kv-tab-reporting-uat"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    kv_admin_objects_ids            = ["f3dfca96-c00c-4ab2-84e8-d52fa1affb16"]
    kv_reader_objects_ids           = ["711873bb-69e8-48c5-a118-e0928fe33b8a"]
    kv_secrets_user_objects_ids     = ["711873bb-69e8-48c5-a118-e0928fe33b8a"]
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
    env                             = "uat"
    tags                            = { "environment" = "uat", "managedBy" = "Terraform" }
    name                            = "lh-kv-tab-express-uat"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    kv_admin_objects_ids            = ["2a46be0d-3a3f-4d89-bb93-937d6b28e02a"]
    kv_reader_objects_ids           = ["e17f5c5c-357b-4a17-b7c0-e88f52b1816b"]
    kv_secrets_user_objects_ids     = ["e17f5c5c-357b-4a17-b7c0-e88f52b1816b"]
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
    env                             = "prod"
    tags                            = { "environment" = "prod", "managedBy" = "Terraform" }
    name                            = "lh-kv-tab-py-prod"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    kv_admin_objects_ids            = ["cead64d8-604b-4f17-bf07-bdc2da4baf4e"]
    kv_reader_objects_ids           = ["a2e2fe8b-9350-493f-ae1e-5d37d99378a5"]
    kv_secrets_user_objects_ids     = ["a2e2fe8b-9350-493f-ae1e-5d37d99378a5"]
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
    env                             = "prod"
    tags                            = { "environment" = "prod", "managedBy" = "Terraform" }
    name                            = "lh-kv-bi-py-prod"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    kv_admin_objects_ids            = ["52a85030-6a8a-477f-b4b3-71fdb8c515ae"]
    kv_reader_objects_ids           = ["8aa7b8a4-c618-4a3e-ac1d-aec494c955f3"]
    kv_secrets_user_objects_ids     = ["8aa7b8a4-c618-4a3e-ac1d-aec494c955f3"]
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
    env                             = "prod"
    tags                            = { "environment" = "prod", "managedBy" = "Terraform" }
    name                            = "lh-kv-bicdn-prod"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    kv_admin_objects_ids            = ["3d63bb53-6102-4ef0-ad41-20df6bcd37a4"]
    kv_reader_objects_ids           = ["55ba8d71-1434-48f0-bc67-99806ad6f08c"]
    kv_secrets_user_objects_ids     = ["55ba8d71-1434-48f0-bc67-99806ad6f08c"]
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
    env                             = "uat"
    tags                            = { "environment" = "uat", "managedBy" = "Terraform" }
    name                            = "lh-kv-drpay-uat"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    kv_admin_objects_ids            = ["64464a81-da54-4464-8fad-adad0eba7631"]
    kv_reader_objects_ids           = ["161ff457-6584-4048-be58-eca2b7e49a83"]
    kv_secrets_user_objects_ids     = ["161ff457-6584-4048-be58-eca2b7e49a83"]
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
    env                             = "prod"
    tags                            = { "environment" = "prod", "managedBy" = "Terraform" }
    name                            = "lh-kv-drpay-prod"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    kv_admin_objects_ids            = ["968d9776-f2ea-44ca-afa9-da51cd7efc68"]
    kv_reader_objects_ids           = ["7dcf5942-231d-47ec-80fa-d4aa2b33b5f1"]
    kv_secrets_user_objects_ids     = ["7dcf5942-231d-47ec-80fa-d4aa2b33b5f1"]
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
    env                             = "prod"
    tags                            = { "environment" = "prod", "managedBy" = "Terraform" }
    name                            = "lh-kv-availity-prod"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    kv_admin_objects_ids            = ["95192d8f-5fa7-4817-ad33-69d2890d6615"]
    kv_reader_objects_ids           = ["4e6a66e5-5892-469d-8921-61503a36457e"]
    kv_secrets_user_objects_ids     = ["4e6a66e5-5892-469d-8921-61503a36457e"]
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
    env                             = "uat"
    tags                            = { "environment" = "uat", "managedBy" = "Terraform" }
    name                            = "lh-kv-availity-uat"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    kv_admin_objects_ids            = ["33cd0193-d08e-45ce-a265-611004dbea7e"]
    kv_reader_objects_ids           = ["1e8ad6d7-f59e-4779-93e4-83d407a3c493"]
    kv_secrets_user_objects_ids     = ["1e8ad6d7-f59e-4779-93e4-83d407a3c493"]
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
    env                             = "uat"
    tags                            = { "environment" = "uat", "managedBy" = "Terraform" }
    name                            = "lh-kv-claimsappeal-uat"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    kv_admin_objects_ids            = ["d134d0f5-339e-4f0a-9648-02c844d4707e"]
    kv_reader_objects_ids           = ["3f502a23-d126-4bc8-b496-dda77707e419"]
    kv_secrets_user_objects_ids     = ["3f502a23-d126-4bc8-b496-dda77707e419"]
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
    env                             = "prod"
    tags                            = { "environment" = "prod", "managedBy" = "Terraform" }
    name                            = "lh-kv-claimsappeal-prod"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    kv_admin_objects_ids            = ["3852711e-c04a-4e38-882f-995f653ec3fb"]
    kv_reader_objects_ids           = ["70750946-6444-4a3b-8319-358b35cd003d"]
    kv_secrets_user_objects_ids     = ["70750946-6444-4a3b-8319-358b35cd003d"]
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
    env                             = "prod"
    tags                            = { "environment" = "prod", "managedBy" = "Terraform" }
    name                            = "lh-kv-qa-auto-prod"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    kv_admin_objects_ids            = ["2e96008f-7378-4fdb-9dd3-1deb80eeb02d"]
    kv_reader_objects_ids           = ["8f227159-1817-4460-9d39-cee36d967678"]
    kv_secrets_user_objects_ids     = ["8f227159-1817-4460-9d39-cee36d967678"]
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
