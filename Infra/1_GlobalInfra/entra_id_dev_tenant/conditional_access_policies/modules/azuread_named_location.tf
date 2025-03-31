resource "azuread_named_location" "azure_trusted_ips" {
  display_name = "Azure-Trusted-IPs"
  ip {
    ip_ranges = [
      "20.121.254.164/32" # Azure Firewall EastUS
    ]
    trusted = true
  }
}

resource "azuread_named_location" "bedford" {
  display_name = "BED-Office-IPs"
  ip {
    ip_ranges = [
      "66.97.189.250/32"
    ]
    trusted = true
  }
}

resource "azuread_named_location" "bangalore" {
  display_name = "BLR-Office-IPs"
  ip {
    ip_ranges = [
      "125.22.228.122/32",
      "115.114.49.226/32",
      "121.243.89.48/29",
      "47.247.21.152/29"
    ]
    trusted = true
  }
}

resource "azuread_named_location" "coimbatore" {
  display_name = "CBE-Office-IPs"
  ip {
    ip_ranges = [
      "115.114.46.240/29",
      "122.15.20.176/29"
    ]
    trusted = true
  }
}

resource "azuread_named_location" "trusted_countries" {
  display_name = "Trusted Countries"
  country {
    countries_and_regions = [
      "US",
      "IN",
      "PH"
    ]
    include_unknown_countries_and_regions = false
  }
}
