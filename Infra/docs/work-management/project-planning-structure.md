# Structuring and Defining Work within Azure DevOps Boards

There are many methods to Agile and Scrum. LogixHealth Infrastructure is standardized on using **Epics**, **Features**, and **Tasks** for project and work tracking.

## Contents

- [Epics](#epics)
- [Features](#features)
- [Tasks](#tasks)

## Epics

An Epic is the highest level of a project. The Epic should clearly define the goal of the work that will be structured within. For Infrastructure's sake, a single Epic should be a collection of work to be completed within a **1-3 month** time frame.

### Examples:

- Deploy an Azure landing zone for a new application or service.
- Onboard a new SaaS product.

### What if my project spans longer than 3 months?

It's expected to have Epics that will stretch past the 1-3 month time frame. In such scenarios, we will have a collection of Epics within a top-level Epic to break down the required work.

## Features

Features are specific components or measurable goals required to contribute to achieving part, or in some cases all, of the Epic.

### Examples:

- Designing the network components in deploying an Azure workload (Landing Zone).
- Implementing single sign-on (SSO) as part of onboarding a new SaaS product or platform.

## Tasks

Under a specific feature will be a collection of Tasks required to complete said Feature. A task should be a granular, narrowly defined component of work that contributes to the completion of the Feature. The work should be achievable in hours and days, not weeks or months.

### Examples:

- Define the size of the virtual network to deploy for the Azure workload in the Feature.
- Create an SSO user group for the new SaaS product to assign user access.
