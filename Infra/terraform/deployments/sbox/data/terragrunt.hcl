include "root" {
  path = find_in_parent_folders()
}

include "data" {
  path           = "${get_terragrunt_dir()}/../../_env/data.hcl"
  merge_strategy = "deep"
}

terraform {
  source = "${get_terragrunt_dir()}/../../../modules//main"
}

inputs = {
  resource_groups = {
    data = {
      location = "eastus",
      resources = {
        cdn_profiles = [
          {
            name = "logixhealth",
            endpoint_configs = [
              {
                name        = "epic-fhir",
                origin_name = "epic-fhir-jwkset",
                origin_path = "/epic-fhir",
                host_name   = "lhpublicdatasbox.blob.core.windows.net"
              }
            ]
          }
        ]
      }
    }
  }
}
