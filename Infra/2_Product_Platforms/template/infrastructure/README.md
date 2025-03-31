# Product Platform Landing Zones

This template example deploys a new subscription, with the standard networking to connect back into the Hub vNet. Additional shared resources for the product platform should be added to the various .bicep files, according to the needed deployment scope for each resource.

## Setup

1. Checkout the repo
2. Create a new feature branch
3. Copy this template folder and paste it within the 2_Product_Platforms parent folder, renaming the folder to reflect the new product

## Adjust the mg.bicep, sub.bicep, and rg.bicep files

Resources that need to be deployed at the various deployment scopes should be added to the respective file:

- **mg.bicep** = [Management Group deployment scope](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-to-management-group?tabs=azure-cli)
- **sub.bicep** = [Subscription deployment scope](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-to-subscription?tabs=azure-cli)
- **rg-\*.bicep** = [Resource Group deployment scope](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-to-resource-group?tabs=azure-cli)

1. Remove (or comment out) modules that are not needed.
1. Modify the bicep files to replace all the parameters with the needed values
1. Add other resources by referencing LH's curated Bicep modules that are available in one of these locations:
   1. Private Azure Container Registry (TBD location / instructions)
      1. TODO: Add URL
   2. Unpublished modules at 0_Global_Library/infrastructure_templates/bicep/local-unpublished
1. The sub.bicep file has an example of calling a local-unpubished module and passing it the needed parameter values.

NOTE: You might need to deploy new landing zones in a staged manner. First, deploy the contents of the mg.bicep file, then sub.bicep, then rg.bicep. If you already have resources / modules defined in the lower files, you can temporarily comment them out.

### Requesting / contributing a new custom module

If you need to deploy or manage a resource which does not have a LH custom module available, you have a few options.

- Define your own resource
  - Reference the LH requirements and best practices for Azure Resource Management
    - TODO: URL(s) to documentation
    - Naming Convention
    - Security Policies
    - Azure Policy guardrails to be aware of
    - TODO: what other requirements / considerations need to be included here?
- Use a public Bicep Module
  - We recommend checking what modules are available from the CARML GitHub repo which have Microsoft's best practices built in.
    - [Microsoft's Curated Azure Resource Module List (CARML)](https://github.com/Azure/ResourceModules)
    - NOTE: This repo is going through some major changes in an effort to align with Azure Verified Modules principles and consolidate to the Public Bicep Registry
  - Other public Bicep Module repos are:
    - [Public Bicep Registry](https://azure.github.io/bicep-registry-modules/)
  - Once you've identified a module to use, it is required to clone the module into our Private Azure Container Registry
    - TODO: Add URL to guide on this process
    - TODO: Does a process need to be defined to scan / validate these modules internally before publishing to the Private ACR?
    - TODO: include steps to update modules as upstream versions are released
    - It is a security requirement to reference a local clone of any 3rd party code / images. Do not reference the public modules directly.
  - The module should also be customized (or abstracted) to include the same LH requirements covered in the "Define your own resource" option above. Usually, it is best to create a wrapper for one of the public modules to bring in the LH customizations. An example of that is: 0_Global_Library/infrastructure_templates/bicep/local-unpublished/vnet.V1.bicep.
  -

## Adjust the pipeline.yml file

1. Adjust the pipeline.yml file:
   1. There is guidance included in the file's comments
   2. TODO: when should we define and use new ADO Environments?
1. Commit your changes frequently, which descriptive yet concise commit messages
1. Push the branch to the "origin" repo

## Create the new pipeline and activate the build validation rule

1. In ADO, create a new pipeline and point it to the new pipeline.yml file in your new product folder
   1. This will enable automated CI jobs, based on triggers defined in the pipeline.yml file you point it to
1. Edit the branch policies for the master branch, then add a new build validation rule, copying an existing rule and updating the path filter(s) to point to the new product folder
   1. This will enable automated CI jobs when Pull Requests are created and require that those jobs complete successfully before the code can be merged into master

## Linting, Testing & Pull Requests

Future commits that are pushed to the upstream feature branch will have an automated CI job initiated to build the code. For Bicep files, this is a good first test to lint the code or make sure there are no basic syntax errors.

Once you're done developing your code and have pushed all of the changes to the upstream feature branch with a successful build job, submit a pull request to merge the feature branch into the master branch. Once created, a new pipeline run will start with the Test stage included. For Bicep files, this will run "validate" and "what-if" task to do a deeper check for errors and also show what changes would be made within the Azure environment.

## Reviewing, Approving and Merging

Someone other than the person who developed the code in the feature branch should review the pull request, looking for:

- Code quality
- Comments and documentation explaining why things were done that way
- Alignment with requirements, standards and best practices
- No unintended changes will be deployed, especially related to destructive code changes
  - This is especially relevant for IaC code deployments. It is possible to do VERY bad things if not careful

## Deployment

Once you're ready to deploy or change the product's landing zone...

- Complete the pull request
- Once the code is merged into the master branch, a new pipeline run will trigger to include the Deploy (and Destroy) stage (if enabled in the pipeline config)
- When the deployment completes, verify that the resources were deployed or changed as intended.
- Monitor the changed environment to validate product performance and availability was not negatively impacted.
- If there are issues with the deployment, consider if a rushed code change should be pushed through or if roll-back is necessary.

## Roll-back

If a roll-back is needed... it is recommended to revert the commit(s) and redeploy. There are scenarios where this does not roll-back all changes performed by a deployment. Manual intervention is likely necessary. If this is a hard requirement, it may be necessary to utilize a tool like Terraform instead of Bicep.

TODO: add more here.

References:

- <https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/rollback-on-error>

## Resource Lifecycle Management

It is recommended to explore using [Deployment Stacks](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-stacks?tabs=azure-cli). At the time of this writing, they are still in Public Preview. Once they go GA, test them out because they should make the lifecycle management of resources much easier.

### Modifying resources

If you have the code that was used to deploy the resource, you can modify it to modify the resource. Make sure to check the what-if job output in the pull request to validate the changes match expectations.

### Deleting resources

The pipeline.yml file has a destroyItems parameter. This currently only supports deleting entire resource groups. It should be possible to add logic to handle other types of deletions as needed in the AzureCLI.V1.Destroy.yml file, then adding the resources to delete into the pipeline.yml file as items under the destroyItems parameter.

The Destroy stage is only executed once a pull request is completed and merged into the master branch.
