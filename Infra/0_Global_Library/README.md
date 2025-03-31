# Global Library

## Overview

The bottom layer is the global library, which is a repository of useful tidbits that aren't deployed into production. From the perspective of access control, read access should be provided to anyone at LogixHealth who requests it. For changes, suggestions, and so on, the Cloud Center of Excellence (CCoE) should approve PRs and manage a backlog as if this were any other product.

Layer 0 should not contain:

- Templates that are deployed in production.
- Secrets or environment-specific configurations.

Layer 0 should contain:

- Code snippets (in Python, C#, and so on).
- Azure Policy samples.
- ARM templates, Bicep templates, or Terraform files that can be used as samples.

An example of this is a sample architecture for how your company would write a deployment for a three-tier application without any environment-specific information. This sample architecture could include tags, networks, network security groups, and so on. Leaving out specific information for the environment is useful, because not everything can be or needs to be put into a module. Trying to do so can result in over-parameterization.

In addition, Layer 0 could link to other known good sources of sample code, such as the Terraform Registry or Azure Resource Modules). If your organization adopts code or a pattern from either of those sources, we recommend pulling the code or pattern into your own Layer 0 instead of pulling directly from the public sources. By relying on your Layer 0, you can write your own tests, tweaks, and security configurations. By not relying on public sources, you reduce the risk of relying on something that could be unexpectedly deleted.

To be considered good sample code, your templates and modules should follow good development practices, including input validation for security and for organizational requirements. To maintain this level of rigor, you should add policies to the main branch to require pull requests (PRs) and code reviews for proposed changes that would result in changes flowing to the main container registry if merged.

Layer 0 feeds into Azure Pipelines or GitHub Actions to automatically create versioned artifacts in Azure Container Registry. You can build automation for git commit messages to implement semantic versioning of the artifacts. For this to work correctly, you need to have a deterministic naming standard, such as <service>.bicep, to make the automation maintainable over time. With proper branch policies, you can also add integration tests as a prerequisite for code reviews. You can instrument this by using tools like Pester.

With such policies and protections in place, the container registry can be the source of truth for all infrastructure modules in the enterprise that are ready to use. You should consider standardizing change logs, as well as indices of available code samples, to allow for discoverability of this code. Unknown code is unused code!
