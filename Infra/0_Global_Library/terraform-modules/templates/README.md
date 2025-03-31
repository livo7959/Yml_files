# Overview

This is our standardized Terraform module template following internal best practices. It provides a consistent terraform module structure for infrastructure-as-code with separate files for resources, variables, outputs, and local values. Every Terraform module should include an example directory for how to use the module and a README.md file automatically generated using terraform-docs. We leverage the common/constants module within our locals.tf file to enforce resource naming constraints and validations through regex patterns including environment restrictions, case sensitivity rules, alphanumeric patterns, and region short name to long name mappings (example: eus to eastus).

# Directory Structure

base-module/
├── examples/
│ ├── main.tf
├── main.tf
├── locals.tf
├── outputs.tf
├── variables.tf
└── README.md

# Resource Abbreviations

We prefix our Azure resource names according to Microsoft's recommended [abbreviations for Azure resources](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations).

# README.md

We use Terraform Docs to generate README.md files.

Installation instructions can be found [here](https://github.com/terraform-docs/terraform-docs)

In the working directory , run the ./docs_generate.sh script

# Tags

We are utilizing [git tags](https://git-scm.com/book/en/v2/Git-Basics-Tagging) to version our Terraform modules via [semantic versioning](https://semver.org/).
