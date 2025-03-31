import { Git, Project, Provider } from "@pulumi/azuredevops";

/** We have reserved the "logixhealth" organization, which serves as the base URL. */
const provider = new Provider("this", {
  orgServiceUrl: "https://dev.azure.com/logixhealth",
});

/**
 * Under "https://dev.azure.com/logixhealth", there exist containers called "Projects".
 * Currently, the whole company exists under one project of "LogixHealth".
 */
const project = new Project(
  "this",
  {
    name: "Main",

    // We do not use some features of AZDO, so we disable them to clean up the GUI.
    features: {
      testplans: "disabled",
    },
  },
  {
    provider,
  },
);

// ------------
// Repositories
// ------------

new Git(
  "infrastructure",
  {
    name: "infrastructure",
    initialization: {
      initType: "Clean",
    },
    projectId: project.id,
  },
  {
    provider,
  },
);

new Git(
  "LogixApplications",
  {
    name: "LogixApplications",
    initialization: {
      initType: "Clean",
    },
    projectId: project.id,
  },
  {
    provider,
  },
);

// TODO: permissions
// TODO: pipelines
