inputs = {
  resource_groups = {
    online-data = {
      location = "eastus",
      resources = {
        storage_accounts = [
          {
            name                            = "lhpublicdata",
            account_tier                    = "Standard",
            account_replication_type        = "LRS",
            account_kind                    = "StorageV2",
            access_tier                     = "Hot",
            allow_nested_items_to_be_public = true,
            public_network_access_enabled   = true,
            public_network_access_vnet_ip   = false,
            sftp_enabled                    = false,
            hns_enabled                     = true,
            containers = [
              {
                name                  = "epic-fhir"
                container_access_type = "blob"
              }
            ]
          }
        ]
      }
    }
  }
}
