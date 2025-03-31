key_vaults = [
  {
    name                          = "loopexone"
    location                      = "eus"
    environment                   = "sbox"
    public_network_access_enabled = true
    rbac_authorization_enabled    = true
    network_acls = [
      {
        bypass                     = "AzureServices"
        default_action             = "Deny"
        ip_rules                   = ["66.97.189.250"]
        virtual_network_subnet_ids = []
      }
    ]
  },
  {
    name                  = "loopextwo"
    location              = "eus"
    environment           = "dev"
    sku_name              = "standard"
    kv_reader_objects_ids = ["b26d3edd-673c-4988-b46a-d75adf14678e"]
    pim_assignments = {
      kv_admin_pim_eligible_object_ids = ["b26d3edd-673c-4988-b46a-d75adf14678e"]
    }
    pim_eligibility_duration_days = 45
    create_service_principal      = true
    public_network_access_enabled = true
    network_acls = [
      {
        bypass                     = "AzureServices"
        default_action             = "Deny"
        ip_rules                   = ["66.97.189.250"]
        virtual_network_subnet_ids = []
      }
    ]
    # Other fields can be omitted to use default values
  }
]

