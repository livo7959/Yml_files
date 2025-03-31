# Applications

## Overview

Layer 3, the application layer, includes the components that are built on top of the product platform. These components deliver the features that the business requests. For example, for a streaming platform, one app could provide the search function while a different app provides recommendations.

Layer 3 should contain:

- Application code in C#, Python, and so on.
  - IMPORTANT: LH is opting to keep application code separate from infrastructure code. There is likely going to be some value in eventually consolidating or integrating application-specific IaC with its application code for optimizing the CI/CD process, reducing cloud costs, etc. This should be revisited at some point.
- Infrastructure for individual components (that's, only used in this application): functions, Azure Container Instances, Event Hubs.

Permissions are restricted for the ability to push changes to this part of the repository. You should use branch protection to enable a team member of this application to approve a PR made by another team member. Team members shouldn't be allowed to approve their own changes. Since this layer could contain proprietary architecture, business logic, or similar information, you might choose to restrict access to those in the organization who build this application. However, if that's the case, you should also build a process of harvesting good practices and snippets from this layer to share with the global library, Layer 0.

## Structure

Folders of applications are created here.
