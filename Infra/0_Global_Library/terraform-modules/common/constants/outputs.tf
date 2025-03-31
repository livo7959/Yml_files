output "default_tags" {
  description = "These are tags that will be applied to all resources created by our company Terraform templates."
  value = {
    managedBy = "terraform"
  }
}

output "kebab_case_regex" {
  description = "https://developer.mozilla.org/en-US/docs/Glossary/Kebab_case"
  value       = "^[a-z0-9]+(-[a-z0-9]+)*$"
}

output "lowercase_regex" {
  value = "^[a-z]+$"
}

output "lowercase_and_numbers_regex" {
  value = "^[a-z0-9]+$"
}

output "region_short_name_to_long_name" {
  description = "https://www.jlaundry.nz/2022/azure_region_abbreviations/"
  value = {
    "eus" : "eastus"
    "eus2" : "eastus2"
    "wus" : "westus"
    "wus2" : "westus2"
    "wus3" : "westus3"
    "cus" : "centralus"
    "ncus" : "northcentralus"
    "scus" : "southcentralus"
    "wcus" : "westcentralus"
  }
}

output "valid_environments" {
  description = "The shorthand strings representing the different deployment environments"
  value = [
    "sbox",  # Sandbox
    "dev",   # Development
    "qa",    # Quality Assurance
    "uat",   # User Acceptance Testing
    "stg",   # Staging
    "prod",  # Production
    "shared" # Shared (Development, Quality Assurance, User Acceptance Testing / Staging, & Production)
  ]
}
