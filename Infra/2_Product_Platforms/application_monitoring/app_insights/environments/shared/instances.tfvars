resource_group_name = "rg-app-insights-shared"
location            = "eastus"

resource_group_tags = {
  environment = "shared"
  managedBy   = "terraform"
}

# Each application insights instance is mapped to a specific virtual machine. For example,
# "appi-saas-dev" corresponds to "BEDDSAAS001".


instances = [
  # BEDDSAAS001
  # BEDDTOOLS001
  {
    name             = "appi-saas-dev"
    application_type = "web"
    tags = {
      environment = "dev"
      managedBy   = "terraform"
    }
  },
  # BEDUSAAS001
  {
    name             = "appi-saas-uat"
    application_type = "web"
    tags = {
      environment = "uat"
      managedBy   = "terraform"
    }
  },
  # BEDPOPS001 & 002
  {
    name             = "appi-saas-prod"
    application_type = "web"
    tags = {
      environment = "prod"
      managedBy   = "terraform"
    }
  },
  # BEDDSVC001
  {
    name             = "appi-microsvc-dev"
    application_type = "web"
    tags = {
      environment = "dev"
      managedBy   = "terraform"
    }
  },
  # BEDUSVC001
  {
    name             = "appi-microsvc-uat"
    application_type = "web"
    tags = {
      environment = "uat"
      managedBy   = "terraform"
    }
  },
  # BEDPSVC001 & 002
  {
    name             = "appi-microsvc-prod"
    application_type = "web"
    tags = {
      environment = "prod"
      managedBy   = "terraform"
    }
  },
  # BEDDAPPPM001
  # BEDDWEBPM001
  {
    name             = "appi-bill-dev"
    application_type = "web"
    tags = {
      environment = "dev"
      managedBy   = "terraform"
    }
  },
  # BEDUAPPPM001
  # BEDUWEBPM001
  {
    name             = "appi-bill-uat"
    application_type = "web"
    tags = {
      environment = "uat"
      managedBy   = "terraform"
    }
  },
  # BEDPAPPBILL001
  # BEDPWEBBILL001
  {
    name             = "appi-bill-prod"
    application_type = "web"
    tags = {
      environment = "prod"
      managedBy   = "terraform"
    }
  },
  # BEDDAUTOENG001
  # BEDDAUTO001
  {
    name             = "appi-autoeng-dev"
    application_type = "web"
    tags = {
      environment = "dev"
      managedBy   = "terraform"
    }
  },
  # BEDUATUO001 & 002
  # BEDUAUTOENG001
  {
    name             = "appi-autoeng-uat"
    application_type = "web"
    tags = {
      environment = "uat"
      managedBy   = "terraform"
    }
  },
  # BEDPAUTO001
  # BEDPAUTOENG001
  {
    name             = "appi-autoeng-prod"
    application_type = "web"
    tags = {
      environment = "prod"
      managedBy   = "terraform"
    }
  },
  # BEDDCV001
  {
    name             = "appi-cv-dev"
    application_type = "web"
    tags = {
      environment = "dev"
      managedBy   = "terraform"
    }
  },
  # BEDUCV001
  {
    name             = "appi-cv-uat"
    application_type = "web"
    tags = {
      environment = "uat"
      managedBy   = "terraform"
    }
  },
  # BEDPCV001-005
  {
    name             = "appi-cv-prod"
    application_type = "web"
    tags = {
      environment = "prod"
      managedBy   = "terraform"
    }
  },
  # This is a general purpose instance that is not tied to a specific VM but is instead used various
  # infrastructure microservices.
  {
    name             = "appi-infrastructure"
    application_type = "other"
    tags = {
      environment = "prod"
      managedBy   = "terraform"
    }
  },
]
