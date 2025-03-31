existing_resource_group = "rg-kv-standalone-dev"

key_vaults = [
  {
    name        = "integrator"
    location    = "eus"
    environment = "dev"
    sku_name    = "standard"
    kv_reader_member_object_ids = [
      "e00a1388-ceb8-4e7f-9284-0b03d50684ff", # Vishnu Vardhan Tenali
      "85424ecd-92f5-4aba-93e8-841563844106", # Dinesh Thangavel
      "d6e231af-e159-4add-98ce-305601e3d17a", # Francis Xavier
      "0334b28f-82c7-4fd1-b68e-3df8df854545", # Arivazhagan Asaithambi
      "867af83b-a050-496d-93ae-d443174164e5", # Santhakumar Rajendran
      "7fe7442f-ab2b-461e-a16f-b425dc3ed96f", # Venkatesan Kumaravel
      "a0c54900-82d9-441a-a6b3-521aab142714", # Kishor Ramesh
      "82a93a27-b07e-4edb-9732-9757529d83e7"  # Mushtaq Riyaz Ahamed
    ]
    pim_assignments = {
      kv_admin_pim_eligible_object_ids = [
        "e00a1388-ceb8-4e7f-9284-0b03d50684ff", # Vishnu Vardhan Tenali
        "85424ecd-92f5-4aba-93e8-841563844106", # Dinesh Thangavel
        "d6e231af-e159-4add-98ce-305601e3d17a", # Francis Xavier
        "0334b28f-82c7-4fd1-b68e-3df8df854545"  # Arivazhagan Asaithambi
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
    environment = "dev"
    sku_name    = "standard"
    kv_reader_member_object_ids = [
      "d04f4dd5-885b-4c7b-a57e-a7c1610d9dcd", # Jin Wang
      "3c4014e6-8784-4423-9d53-c6ab7163e53e", # Nicholas Mann
      "de9ae1d6-8ddd-4a70-9c20-37d9f279f1ba", # Vasanth Kumar Katragadda
      "3f4eb6ac-a1ca-4652-9cd2-d6e9d8069dbb", # Joshua LaPlante
      "ed515fa1-f396-4e77-ae48-9dc9a9d660f1"  # Akhila Kishore
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
    name        = "ivr"
    location    = "eus"
    environment = "dev"
    sku_name    = "standard"
    kv_reader_member_object_ids = [
      "3f4eb6ac-a1ca-4652-9cd2-d6e9d8069dbb", # Joshua LaPlante
      "de9ae1d6-8ddd-4a70-9c20-37d9f279f1ba", # Vasanth Kumar Katragadda
      "24a95ab4-6c06-4167-8892-397e2720ed9b"  # Mukunda Channapatna
    ]
    pim_assignments = {
      kv_admin_pim_eligible_object_ids = [
        "3f4eb6ac-a1ca-4652-9cd2-d6e9d8069dbb", # Joshua LaPlante
        "de9ae1d6-8ddd-4a70-9c20-37d9f279f1ba", # Vasanth Kumar Katragadda
        "24a95ab4-6c06-4167-8892-397e2720ed9b"  # Mukunda Channapatna
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
    name        = "bicdn"
    location    = "eus"
    environment = "dev"
    sku_name    = "standard"
    kv_reader_member_object_ids = [
      "337faffa-1c79-4ef1-ad16-ec56712b4f5e", # Karnatakam Saicharan Reddy
      "5130d8a5-5521-4319-9bb3-f23b6755a5fc", # Shakir Ali Shaik
      "5f33514a-89e8-411f-a506-631bf7847125"  # BEDDBICDN001
    ]
    pim_assignments = {
      kv_admin_pim_eligible_object_ids = [
        "337faffa-1c79-4ef1-ad16-ec56712b4f5e", # Karnatakam Saicharan Reddy
        "5130d8a5-5521-4319-9bb3-f23b6755a5fc"  # Shakir Ali Shaik
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
  }
]
