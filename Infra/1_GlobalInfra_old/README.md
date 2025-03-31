# Global Infrastructure

## Overview

Layer 1 is the repository for your Azure landing zone constructs. While Microsoft supplies templates for the deployment of Azure landing zones, you'll want to modify certain components and supply a parameters file. This is analogous to the way that you pull public registry and module repositories into Layer 0, as described earlier.

Azure Container Registry is a critical part of this architecture. Even if your company has no plans to use containers, you must deploy Container Registry to succeed in versioning Bicep templates. Container Registry enables significant flexibility and reusability for your modules while providing enterprise-grade security and access control.

Layer 1 should contain:

- Policy assignments and definitions that are applied at the level of management group or subscription. These policies should match your corporate governance requirements.
- Templates for core network infrastructure, such as ExpressRoute, VPNs, virtual WAN, and virtual networks (shared or hub).
- DNS.
- Core monitoring (log analytics).
- Enterprise container registry.

You should configure branch protection to restrict the ability to push changes to this repository. Restrict approval of PRs from other developers to members of the CCoE or Cloud Governance. Contributors to this layer are primarily members of groups that are historically associated with the components in this layer. For example, the networking team builds the templates for the network, the operations team configures monitoring, and so on. However, you should grant read-only access to individuals who request it, because you want to enable developers from other groups to suggest changes to the core infrastructures. They may contribute improvements, though you won't allow their changes to be merged without approval and testing.

These files should consume the modules in your container registry for standard components. However, you'll also have a Bicep file, or a series of Bicep files, that are customized to your enterprise's implementation of Azure landing zones or a similar governance structure.
