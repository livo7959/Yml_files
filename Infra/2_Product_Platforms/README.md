# Product Platforms

## Overview

You can consider Layer 2, product platform, as the shared services for a particular product line or business unit. These components aren't universal across the organization, but they're meant to fit a particular business need. This would be an appropriate layer for a virtual network that's a peer with the hub in Layer 1, global infrastructure. A key vault is another example component for this layer. The key vault could store shared secrets to a storage account or a database that's shared by the different applications within this platform.

Layer 2 should contain:

- Policy assignments that are applied at a subscription or resource group to match product-specific requirements.
- IaC templates for key vaults, log analytics, an SQL database (if various applications within the product use the database), and Azure Kubernetes Service.

Permissions need to be implemented that restrict the ability to push changes to this portion of the repo. Like the other layers, you should use branch protection to make sure a product lead or owner can approve PRs from other developers. There are no fixed rules about read access to the product platform, but at a minimum, developers from any of the application teams should be granted read access to be able to suggest changes. Since Layer 2 could contain some proprietary architecture, or similar information, you might choose to restrict access to those in the organization who use the platform. However, if that's the case, you'll want to ensure that you build a process of harvesting good practices and snippets from this repository to share with the global library, Layer 0.

### What is a product?

A product is similar to Microsoft's [concept of a workload](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/plan/workloads#what-is-a-workload) in their Cloud Adoption Framework (CAF).

> In cloud adoption, a workload is a collection of IT assets (servers, VMs, applications, data, or appliances) that collectively support a defined process. Workloads can support more than one process. Workloads can also depend on other shared assets or larger platforms. However, a workload should have defined boundaries regarding the dependent assets and the processes that depend upon the workload. Often, workloads can be visualized by monitoring network traffic among IT assets.

## Structure

Folders of product names should be created in here.

## Usage

For deploying new product platform landing zones, you should refer to the [template/infrastructure/README.md file](./template/infrastructure/README.md)
