# Input variables
hp-rgname            = "rg-test-hostpool"
prefix               = "avd-T214-B"
hp-rgname-location   = "eastus"
rfc3339              = "2025-02-27T12:43:13Z"
avdsub               = "snet-avd-eus-001"
vnetname             = "vnet-avd-eus-001"
rg-vnet              = "rg-net-avd-eus-001"
rdsh_count           = 2
vm_size              = "Standard_D8s_v5"
local_admin_username = "lhavdlocaladmin"
source_image_id      = "/subscriptions/32759c43-ba2f-4ddc-8298-c1e77c1cfb35/resourceGroups/rg-vdi-images/providers/Microsoft.Compute/galleries/vdi_Images/images/VM-Billing-img/versions/2.14.25"
domain_name          = "corp.logixhealth.local"
domain_user_upn      = "svc_joindomain"
ou_path              = "OU=AVD-Test-Desktops,OU=VDI,OU=Azure-EastUS,OU=Cloud-Datacenters,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
datacollectionrule   = "microsoft-avdi-eastus"
rgalerts             = "rg-alerts" //resource group where Data collection rule exists
hostpool             = "hp-test"
