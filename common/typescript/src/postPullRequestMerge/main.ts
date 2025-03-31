import type { IGitApi } from "azure-devops-node-api/GitApi.js";
import { parseIntSafe, trimPrefix } from "complete-common";
import { getArgs } from "complete-node";
import {
  azureDevOpsError,
  getGitAPI,
  getLastCommitMessage,
} from "../azureDevOps.js";
import { deleteBranchFromLastPR } from "./deleteBranchFromLastPR.js";

await main();

async function main() {
  // --------------------------
  // Validate script arguments.
  // --------------------------

  const args = getArgs();
  const [accessToken, collectionURI, projectID, repositoryID] = args;

  if (accessToken === undefined || accessToken === "") {
    azureDevOpsError(
      "This script requires the access token to be passed as the 1st argument.",
    );
  }

  if (collectionURI === undefined || collectionURI === "") {
    azureDevOpsError(
      "This script requires the collection URI to be passed as the 2nd argument.",
    );
  }
  console.log(`Passed collection URI: ${collectionURI}`); // e.g. "https://azuredevops.logixhealth.com/LogixHealth/"

  if (projectID === undefined || projectID === "") {
    azureDevOpsError(
      "This script requires the project ID to be passed as the 3rd argument.",
    );
  }
  console.log(`Passed project ID: ${projectID}`); // e.g. "f538b700-1f79-4eff-b97b-f416dcac1e8e"

  if (repositoryID === undefined || repositoryID === "") {
    azureDevOpsError(
      "This script requires the repository ID to be passed as the 4th argument.",
    );
  }
  console.log(`Passed repository ID: ${repositoryID}`); // e.g. "37ec22be-85c7-4332-a5f8-6215331a8ebe"

  // -------------------------------------------------
  // Gather information to be used in the below tasks.
  // -------------------------------------------------

  const gitAPI = await getGitAPI(accessToken, collectionURI);
  const pullRequestID = await getPullRequestIDFromLastCommit(
    gitAPI,
    projectID,
    repositoryID,
  );
  const pullRequest = await gitAPI.getPullRequestById(pullRequestID);

  /** Will be something like: refs/heads/feature/LogixConnect/jnesta/foo */
  const branchNameWithRefPrefix = pullRequest.sourceRefName;
  if (branchNameWithRefPrefix === undefined) {
    azureDevOpsError(
      `Failed to get the source branch name from pull request: ${pullRequestID}`,
    );
  }
  const branchName = trimPrefix(branchNameWithRefPrefix, "refs/heads/");

  // --------------
  // Perform tasks.
  // --------------

  await deleteBranchFromLastPR(gitAPI, projectID, repositoryID, branchName);
}

async function getPullRequestIDFromLastCommit(
  gitAPI: IGitApi,
  projectID: string,
  repositoryID: string,
): Promise<number> {
  const lastCommitMessage = await getLastCommitMessage(
    gitAPI,
    projectID,
    repositoryID,
  );

  const match = lastCommitMessage.match(
    /^(?:Merge|Merged) (?:PR|pull request) (\d+)/,
  );
  if (match === null) {
    azureDevOpsError(
      `Failed to parse the pull request ID from the last commit message of: ${lastCommitMessage}`,
    );
  }

  const pullRequestIDString = match[1];
  if (pullRequestIDString === undefined || pullRequestIDString === "") {
    azureDevOpsError(
      "Failed to parse the pull request ID from the regular expression match.",
    );
  }

  const pullRequestID = parseIntSafe(pullRequestIDString);
  if (pullRequestID === undefined) {
    azureDevOpsError(
      `The pull request ID of "${pullRequestIDString}" is not a number.`,
    );
  }

  return pullRequestID;
}
