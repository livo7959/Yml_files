# Azure DevOps Agent Notes

Azure DevOps allows you to have multiple "agents" that run pipelines. In our case, agents are virtual machines that both run checks and serve production applications.

To install a new agent:

- Create a new personal access token. Do not give it full permissions. Instead, only give it the "Agent pools (Read & manage)" permissions as documented [here](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/personal-access-token-agent-registration?view=azure-devops).
- Download the latest agent software by going to the [Agent Pools section of AZDO](https://azuredevops.logixhealth.com/LogixHealth/_settings/agentpools), clicking on an arbitrary agent pool, and then clicking on button in the top-right-hand corner for "New Agent", and then clicking on "Download".
- Copy the zip file to the remote server and extract it.
- Run `config.cmd`.
  - You must use the following URL: `https://azuredevops.logixhealth.com`
    - If you use `https://azuredevops.logixhealth.com/`, you may get the following error: `VS30063: You are not authorized to access https://azuredevops.logixhealth.com.` if so user the URL: `https://azuredevops.logixhealth.com/LogixHealth/`
  - Then instead of PAT put Integrate.
  - Enter the agent pool that you want.(press enter for default)
  - Use the default agent name, which will correspond to the name of the virtual machine.
  - Use the default work folder, which will be "\_work".
  - Press Y to run the agent as a Windows service.
  - Press N to not enable `SERVICE_SID_TYPE_UNRESTRICTED`.
  - Enter the corresponding Service account, once done it should start up the service called: `Azure Pipelines Agent(azuredevops.*)`
