# Application Control Plan Management

## Application Control Deployment Plan Overview

1. Define (or refine) the "circle-of-trust" for the policy and build an audit mode version of the policy XML. In audit mode, block events are generated, but files aren't prevented from executing.
1. Deploy the audit mode policy to intended devices.
1. Monitor audit block events from the intended devices and add/edit/delete rules as needed to address unexpected/unwanted blocks.
1. Repeat steps 2-3 until the remaining block events meet expectations.
1. Generate the enforced mode version of the policy. This will be our base policy. In enforced mode, files that the policy doesn't allow are prevented from running, and corresponding block events are generated.
1. Deploy the base enforced mode policy to intended devices, using staged rollouts for enforced policies to detect and respond to issues before deploying the policy broadly.
1. Create Allow Supplemental Policies for different departments that require certain applications as part of their daily functions. This can be added to the base policy and controlled using AAD groups.
1. Deploy the base application control policy to all endpoints.
1. Deploy to servers and virtual machines if needed.
1. Repeat steps 1-6 anytime the desired "circle-of-trust" changes.

## Application Control Technical Overview

### List of Applications Allowed for a Certain Policy

## Application Control Policy Overview

These policies may change based on needs, but the Base policy will always remain the same.

- **Base Policy:** The base policy consists of:

  - Deny All Apps
  - Allow Microsoft Apps
  - Allow Supplemental Policies
  - Allow Managed Installers App

- **IT & Security Supplemental Policy:** This policy consists of:

  - Deny All Apps
  - Allow Microsoft Apps
  - Allow Supplemental Policies
  - Allow Managed Installers App
  - Allow Administrator Tools and Apps (e.g., PowerShell, Active Directory)

- **Developers Supplemental Policy:** This policy consists of:

  - Deny All Apps
  - Allow Microsoft Apps
  - Allow Supplemental Policies
  - Allow Managed Installers App
  - Allow Developer Tools (e.g., Visual Studio)

- **Finance Supplemental Policies:** This policy consists of:

  - Deny All Apps
  - Allow Microsoft Apps
  - Allow Supplemental Policies
  - Allow Managed Installers App
  - Allow Financial Applications (e.g., QuickBooks)

- **Executives Supplemental Policy:** TBD

## How a Policy is Created

A policy can be created using the Windows Defender App Control wizard or through PowerShell. These tools are used to create an XML Policy with various block or allow rules. Below is a quick breakdown of our policy and the references provided by Microsoft to develop our “Base Policy.”

### Policy Breakdown

We started with a template provided by Microsoft:

- **Allow Microsoft Template Policy:**
  - Deny all non-Microsoft applications by default
  - Allow all signed Microsoft applications
  - Allow Windows OS components
  - Allow Office 365, OneDrive, Teams
  - Windows Hardware Quality Labs Certified (WHQL) Signed Kernel Drivers
  - Microsoft Store applications (blocked for everyone except a few limited admins)

### Preset Rules Pre-enabled Based on the Template

- **Advanced Boot Options:** Enabled (This rule option allows the F8 menu to appear for physically present users)
- **Allow Supplemental Policies:** This option allows supplemental policies to expand the base policy.
- **Managed Installer:** This option automatically allows applications installed by a managed installer.
- **Update Policy Without Rebooting**
- **Unsigned System Integrity Policy:** Planning to disable this rule once application control is in place; this will only allow code-signed policies to work on our devices.
- **User Mode Code Integrity**
