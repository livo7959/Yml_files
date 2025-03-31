existing_resource_group = "rg-kv-standalone-dev"

key_vaults = [
  # -------------------------
  # Key vaults for containers
  # -------------------------

  {
    name                          = "test"
    location                      = "eus"
    environment                   = "dev"
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
        "201a126a-b5d2-4762-8ec7-c94b678d0c67" # Tommy T
      ]
    }
  },

  {
    name                          = "foo"
    location                      = "eus"
    environment                   = "dev"
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
        "201a126a-b5d2-4762-8ec7-c94b678d0c67" # Tommy T
      ]
    }
  }
]
