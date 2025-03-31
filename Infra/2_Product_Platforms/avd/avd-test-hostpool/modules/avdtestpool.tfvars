# Input variables
rg_name                 = "rg-test-hostpool"
workspace               = "ws-test-hostpool"
prefix                  = "avdtest"
resource_group_location = "eastus"
custom_rdp_properties   = "drivestoredirect:s:;audiomode:i:2;videoplaybackmode:i:0;redirectclipboard:i:0;redirectprinters:i:0;devicestoredirect:s:;redirectcomports:i:0;redirectsmartcards:i:0;autoreconnection enabled:i:1;enablecredsspsupport:i:1;redirectwebauthn:i:0;use multimon:i:1;bandwidthautodetect:i:1;networkautodetect:i:1;audiocapturemode:i:0;usbdevicestoredirect:s:*"
maxsessions             = 6
load_balancer_type      = "BreadthFirst"
hostpool                = "hp-test"
published_desktop_name  = "testdesktp"

