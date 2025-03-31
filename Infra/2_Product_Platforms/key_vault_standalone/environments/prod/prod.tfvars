existing_resource_group = "rg-kv-standalone-prod"

key_vaults = [
  # -------------------------
  # Key vaults for containers
  # -------------------------

  {
    # "auto-auto-complete" is 25 characters and the maximum length is 9 characters.
    name                          = "autocompl" # cspell:disable-line
    location                      = "eus"
    environment                   = "prod"
    create_service_principal      = true
    public_network_access_enabled = true
    network_acls = [
      {
        bypass                     = "AzureServices"
        default_action             = "Deny"
        ip_rules                   = ["66.97.189.250/32"]
        virtual_network_subnet_ids = []
      }
    ]
    pim_assignments = {
      kv_admin_pim_eligible_object_ids = [
        "3e2bd9ec-54bb-4b99-afc6-a732553c0310" # James Nesta
      ]
    }
  },

  {
    # "charts-data-transfer-service" is 25 characters and the maximum length is 9 characters.
    name                          = "chartsdat" # cspell:disable-line
    location                      = "eus"
    environment                   = "prod"
    create_service_principal      = true
    public_network_access_enabled = true
    network_acls = [
      {
        bypass                     = "AzureServices"
        default_action             = "Deny"
        ip_rules                   = ["66.97.189.250/32"]
        virtual_network_subnet_ids = []
      }
    ]
    pim_assignments = {
      kv_admin_pim_eligible_object_ids = [
        "3e2bd9ec-54bb-4b99-afc6-a732553c0310" # James Nesta
      ]
    }
  },

  {
    name                          = "docs"
    location                      = "eus"
    environment                   = "prod"
    create_service_principal      = true
    public_network_access_enabled = true
    network_acls = [
      {
        bypass                     = "AzureServices"
        default_action             = "Deny"
        ip_rules                   = ["66.97.189.250/32"]
        virtual_network_subnet_ids = []
      }
    ]
    pim_assignments = {
      kv_admin_pim_eligible_object_ids = [
        "3e2bd9ec-54bb-4b99-afc6-a732553c0310" # James Nesta
      ]
    }
  },

  # "fivetran-reverse-ssh" is 20 characters and the maximum length is 9 characters.
  {
    name                          = "fivetran"
    location                      = "eus"
    environment                   = "prod"
    create_service_principal      = true
    public_network_access_enabled = true
    network_acls = [
      {
        bypass                     = "AzureServices"
        default_action             = "Deny"
        ip_rules                   = ["66.97.189.250/32"]
        virtual_network_subnet_ids = []
      }
    ]
    pim_assignments = {
      kv_admin_pim_eligible_object_ids = [
        "3e2bd9ec-54bb-4b99-afc6-a732553c0310" # James Nesta
      ]
    }
  },

  # ----------------
  # Other key vaults
  # ----------------

  {
    name        = "notifysvc"
    location    = "eus"
    environment = "uat"
    sku_name    = "standard"
    kv_reader_member_object_ids = [
    ]
    pim_assignments = {
      kv_admin_pim_eligible_object_ids = [
        "d04f4dd5-885b-4c7b-a57e-a7c1610d9dcd", # Jin Wang
        "3c4014e6-8784-4423-9d53-c6ab7163e53e", # Nicholas Mann
        "de9ae1d6-8ddd-4a70-9c20-37d9f279f1ba", # Vasanth Kumar Katragadda
        "3f4eb6ac-a1ca-4652-9cd2-d6e9d8069dbb", # Joshua LaPlante
        "ed515fa1-f396-4e77-ae48-9dc9a9d660f1"  # Akhila Kishore
      ]
    }
    pim_eligibility_duration_days = 365
    create_service_principal      = true
    public_network_access_enabled = true
    network_acls = [
      {
        bypass                     = "AzureServices"
        default_action             = "Deny"
        ip_rules                   = ["66.97.189.250/32"]
        virtual_network_subnet_ids = []
      }
    ]
  },

  {
    name        = "notifysvc"
    location    = "eus"
    environment = "prod"
    sku_name    = "standard"
    kv_reader_member_object_ids = [
    ]
    pim_assignments = {
      kv_admin_pim_eligible_object_ids = [
        "3f4eb6ac-a1ca-4652-9cd2-d6e9d8069dbb" # Joshua LaPlante
      ]
    }
    pim_eligibility_duration_days = 365
    create_service_principal      = true
    public_network_access_enabled = true
    network_acls = [
      {
        bypass                     = "AzureServices"
        default_action             = "Deny"
        ip_rules                   = ["66.97.189.250/32"]
        virtual_network_subnet_ids = []
      }
    ]
  },

  {
    name        = "ivr"
    location    = "eus"
    environment = "uat"
    sku_name    = "standard"
    kv_reader_member_object_ids = [
    ]
    pim_assignments = {
      kv_admin_pim_eligible_object_ids = [
        "3f4eb6ac-a1ca-4652-9cd2-d6e9d8069dbb", # Joshua LaPlante
        "de9ae1d6-8ddd-4a70-9c20-37d9f279f1ba", # Vasanth Kumar Katragadda
        "24a95ab4-6c06-4167-8892-397e2720ed9b"  # Mukunda Channapatna Parthasarathy
      ]
    }
    pim_eligibility_duration_days = 365
    create_service_principal      = true
    public_network_access_enabled = true
    network_acls = [
      {
        bypass                     = "AzureServices"
        default_action             = "Deny"
        ip_rules                   = ["66.97.189.250/32"]
        virtual_network_subnet_ids = []
      }
    ]
  },
  {
    name        = "ivr"
    location    = "eus"
    environment = "prod"
    sku_name    = "standard"
    kv_reader_member_object_ids = [
    ]
    pim_assignments = {
      kv_admin_pim_eligible_object_ids = [
        "3f4eb6ac-a1ca-4652-9cd2-d6e9d8069dbb", # Joshua LaPlante
        "de9ae1d6-8ddd-4a70-9c20-37d9f279f1ba", # Vasanth Kumar Katragadda
        "24a95ab4-6c06-4167-8892-397e2720ed9b"  # Mukunda Channapatna Parthasarathy
      ]
    }
    pim_eligibility_duration_days = 365
    create_service_principal      = true
    public_network_access_enabled = true
    network_acls = [
      {
        bypass                     = "AzureServices"
        default_action             = "Deny"
        ip_rules                   = ["66.97.189.250/32"]
        virtual_network_subnet_ids = []
      }
    ]
  },
  {
    # Keyvault for defender scanner
    name                          = "msscanner"
    location                      = "eus"
    environment                   = "prod"
    create_service_principal      = true
    public_network_access_enabled = true
    network_acls = [
      {
        bypass                     = "AzureServices"
        default_action             = "Deny"
        ip_rules                   = ["66.97.189.250/32"]
        virtual_network_subnet_ids = []
      }
    ]
    pim_assignments = {
      kv_admin_pim_eligible_object_ids = [
        "4bb12e24-0365-422c-bc3a-6ba299225c74" # Jimmy Theum
      ]
    }
  },
  {
    name                          = "integratr" # had to shorten the name to fit the 9 character limit
    location                      = "eus"
    environment                   = "prod"
    create_service_principal      = true
    public_network_access_enabled = true
    network_acls = [
      {
        bypass                     = "AzureServices"
        default_action             = "Deny"
        ip_rules                   = ["66.97.189.250/32"]
        virtual_network_subnet_ids = []
      }
    ]
    pim_assignments = {
      kv_admin_pim_eligible_object_ids = [
        "e00a1388-ceb8-4e7f-9284-0b03d50684ff", # Vishnu Vardhan Tenali
        "85424ecd-92f5-4aba-93e8-841563844106", # Dinesh Thangavel
        "d6e231af-e159-4add-98ce-305601e3d17a"  # Francis Xavier
      ]
    }
  },
  {
    name                          = "integrator"
    location                      = "eus"
    environment                   = "uat"
    create_service_principal      = true
    public_network_access_enabled = true
    network_acls = [
      {
        bypass                     = "AzureServices"
        default_action             = "Deny"
        ip_rules                   = ["66.97.189.250/32"]
        virtual_network_subnet_ids = []
      }
    ]
    pim_assignments = {
      kv_admin_pim_eligible_object_ids = [
        "e00a1388-ceb8-4e7f-9284-0b03d50684ff", # Vishnu Vardhan Tenali
        "85424ecd-92f5-4aba-93e8-841563844106", # Dinesh Thangavel
        "d6e231af-e159-4add-98ce-305601e3d17a"  # Francis Xavier
      ]
    }
  }
]
