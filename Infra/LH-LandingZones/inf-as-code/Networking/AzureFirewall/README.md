# Azure Firewall (azfw-hub-eus-001)

This directory contains the [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep) code to implement/manage the Azure Firewall. Eventually, this code will be migrated to Terraform.

## Firewall Planning for the Azure Container App Subnet

These are notes for the 10.120.160.0/24 subnet implemented in August/September 2024.

- New rule collection group to be used for server to server traffic. Priority 1600
- Within rule collection group we will have workload specific rules.
- Rules needed for Azure DevOps agents. Start with single linux container to azdo rule.
- Allow 10.120.160.0/25 to azdo via tcp port 443.
- network rule collection should start at priority 100 (this is just our standard not a requirement).
- Palo Alto side: Will need corresponding rule to allow the traffic. One way as connection will be stateful.
