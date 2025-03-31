# terraform.tfvars

# Name of the resource group
resource_group_name = "rg-app-insights-icer"

# Region of the resource group
location = "eastus"

# Resource group tags
resource_group_tags = {
  environment = "shared"
  managedBy   = "terraform"
}

# List object of application insights instances
instances = [
  # BEDDWEBICER001
  # BEDDAPPICER001
  {
    name             = "appi-icer-dev"
    application_type = "web"
    tags = {
      environment = "dev"
      managedBy   = "terraform"
    }
  },
  # BEDUWEBICER001
  # BEDUAPPICER001
  {
    name             = "appi-icer-uat"
    application_type = "web"
    tags = {
      environment = "uat"
      managedBy   = "terraform"
    }
  },
  # BEDPWEBICER001-004
  # BEDPAPPICER001-004
  # BEDPINT001
  # BEDPRRE001-004
  {
    name             = "appi-icer-prod"
    application_type = "web"
    tags = {
      environment = "prod"
      managedBy   = "terraform"
    }
  }
]
