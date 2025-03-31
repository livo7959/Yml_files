# Azure DevOps Services

LogixHealth currently uses Azure DevOps Server, which is an on-prem hosting solution for Git repositories. Our long-term plan is to migrate to Azure DevOps Services, which is the SaaS / cloud version of the same thing.

This directory contains the configuration for the AZDO Services deployment. It uses [Pulumi](https://www.pulumi.com/) and [Dagger](https://dagger.io/) to have [infrastructure as code](https://aws.amazon.com/what-is/iac/).

## Notes

Other useful commands:

- `pulumi refresh` (to refresh the state)
