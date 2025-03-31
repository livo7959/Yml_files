import * as azdo from "azure-devops-node-api";
import type { IGitApi } from "azure-devops-node-api/GitApi.js";
import type { GitPullRequest } from "azure-devops-node-api/interfaces/GitInterfaces.js";
import { GitPullRequestMergeStrategy } from "azure-devops-node-api/interfaces/GitInterfaces.js";
import { assertDefined } from "complete-common";
import { getAzureKeyVaultSecret } from "./azureKeyVault.js";

const AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN = await getAzureKeyVaultSecret(
  "azure-devops-personal-access-token",
);

const COLLECTION_URI = "https://azuredevops.logixhealth.com/LogixHealth";

const gitAPI = await getGitAPI(
  AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN,
  COLLECTION_URI,
);

export async function setAutoCompleteForPullRequest(
  repositoryID: string,
  pullRequestID: number,
): Promise<void> {
  const existingPullRequest = await gitAPI.getPullRequestById(pullRequestID);
  const pullRequestCreatorID = existingPullRequest.createdBy?.id;
  assertDefined(
    pullRequestCreatorID,
    `Failed to get the author ID for the pull request of: ${pullRequestID}`,
  );

  const gitPullRequestToUpdate: Partial<GitPullRequest> = {
    autoCompleteSetBy: {
      id: pullRequestCreatorID,
    },
    completionOptions: {
      mergeStrategy: GitPullRequestMergeStrategy.Squash,
    },
  };

  await gitAPI.updatePullRequest(
    gitPullRequestToUpdate,
    repositoryID,
    pullRequestID,
  );

  console.log(
    `Set auto-complete for pull request "${pullRequestID}" of repository "${existingPullRequest.repository?.name}".`,
  );
}

/** Get an `IGitApi` object, which allows interacting with the Azure DevOps API. */
async function getGitAPI(
  accessToken: string,
  collectionURI: string,
): Promise<IGitApi> {
  const authHandler = azdo.getPersonalAccessTokenHandler(accessToken);
  const connection = new azdo.WebApi(collectionURI, authHandler);
  return await connection.getGitApi();
}
