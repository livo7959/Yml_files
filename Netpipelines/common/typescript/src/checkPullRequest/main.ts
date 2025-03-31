// This is a pipeline that ensures that pull requests pass certain checks.

import { parseIntSafe, trimPrefix } from "complete-common";
import { getArgs } from "complete-node";
import {
  azureDevOpsError,
  getChangedFilePathsInPR,
  getGitAPI,
} from "../azureDevOps.js";
import { getAppNameForPR, getUsernameOfPRAuthor } from "../monorepo.js";
import { checkBranchName } from "./branchName.js";
import { checkMergeCommits } from "./mergeCommits.js";

await main();

async function main() {
  // --------------------------
  // Validate script arguments.
  // --------------------------

  const args = getArgs();
  const [
    accessToken,
    collectionURI,
    projectID,
    repositoryID,
    pullRequestIDString,
  ] = args;

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

  if (pullRequestIDString === undefined || pullRequestIDString === "") {
    azureDevOpsError(
      "This script requires the pull request ID to be passed as the 5th argument.",
    );
  }
  const pullRequestID = parseIntSafe(pullRequestIDString);
  if (pullRequestID === undefined) {
    azureDevOpsError(
      `The pull request ID of "${pullRequestIDString}" is not a number.`,
    );
  }
  console.log(`Passed pull request ID: ${pullRequestID}`);

  // -------------------------------------------------
  // Gather information to be used in the below tasks.
  // -------------------------------------------------

  const gitAPI = await getGitAPI(accessToken, collectionURI);
  const pullRequest = await gitAPI.getPullRequestById(pullRequestID);

  /** Will be something like: refs/heads/feature/LogixConnect/jnesta/foo */
  const branchNameWithRefPrefix = pullRequest.sourceRefName;
  if (branchNameWithRefPrefix === undefined) {
    azureDevOpsError(
      `Failed to get the source branch name from pull request: ${pullRequestID}`,
    );
  }
  const branchName = trimPrefix(branchNameWithRefPrefix, "refs/heads/");

  const changedFilePaths = await getChangedFilePathsInPR(
    gitAPI,
    projectID,
    repositoryID,
    pullRequestID,
  );
  const appName = getAppNameForPR(changedFilePaths);
  const username = getUsernameOfPRAuthor(pullRequest);

  // -------------------
  // Perform validation.
  // -------------------

  await checkMergeCommits(gitAPI, repositoryID, pullRequestID);
  checkBranchName(branchName, appName, username);
}
