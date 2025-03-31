import * as azdo from "azure-devops-node-api";
import type { IGitApi } from "azure-devops-node-api/GitApi.js";
import type {
  GitChange,
  GitCommitRef,
  GitRefUpdate,
} from "azure-devops-node-api/interfaces/GitInterfaces.js";
import { GitVersionType } from "azure-devops-node-api/interfaces/GitInterfaces.js";
import { assertDefined, filterMap } from "complete-common";

/** Get an `IGitApi` object, which allows interacting with the Azure DevOps API. */
export async function getGitAPI(
  accessToken: string,
  collectionURI: string,
): Promise<IGitApi> {
  const authHandler = azdo.getPersonalAccessTokenHandler(accessToken);
  const connection = new azdo.WebApi(collectionURI, authHandler);
  return connection.getGitApi();
}

/**
 * The Azure DevOps API does not directly provide the names of changed files in a pull request.
 * Thus, we must use the `getCommitDiffs` API. (This is more robust than iterating over the files
 * that are changed in each commit of the PR, because it is possible that a file was added and then
 * deleted afterward.)
 *
 * Note that this function will not work properly when being called from a pipeline that is
 * triggered from the master branch (because it does a comparison to the master branch).
 *
 * @see
 * https://stackoverflow.com/questions/59407694/azure-repos-rest-api-to-get-list-of-changed-files-in-merge-request
 */
export async function getChangedFilePathsInPR(
  gitAPI: IGitApi,
  projectID: string,
  repositoryID: string,
  pullRequestID: number,
): Promise<readonly string[]> {
  const lastMasterCommitSHA1 = await getMostRecentCommitSHA1OnMaster(
    gitAPI,
    projectID,
    repositoryID,
  );
  const lastPRCommitSHA1 = await getMostRecentCommitSHA1OnPR(
    gitAPI,
    projectID,
    repositoryID,
    pullRequestID,
  );

  const baseVersionDescriptor = {
    version: lastMasterCommitSHA1,
    versionType: GitVersionType.Commit,
  };
  const targetVersionDescriptor = {
    version: lastPRCommitSHA1,
    versionType: GitVersionType.Commit,
  };

  const gitCommitDiffs = await gitAPI.getCommitDiffs(
    repositoryID,
    projectID,
    true,
    undefined,
    undefined,
    baseVersionDescriptor,
    targetVersionDescriptor,
  );

  const gitChanges = gitCommitDiffs.changes;
  if (gitChanges === undefined) {
    return [];
  }

  return getFilePathsFromGitChanges(gitChanges);
}

function getFilePathsFromGitChanges(
  gitChanges: readonly GitChange[],
): readonly string[] {
  return filterMap(gitChanges, (gitChange) =>
    gitChange.item !== undefined &&
    gitChange.item.path !== undefined &&
    gitChange.item.path !== ""
      ? gitChange.item.path
      : undefined,
  );
}

async function getMostRecentCommitSHA1OnMaster(
  gitAPI: IGitApi,
  projectID: string,
  repositoryID: string,
): Promise<string> {
  const gitRefs = await gitAPI.getRefs(repositoryID, projectID, "heads/master");
  const lastGitRef = gitRefs[0]; // The first commit in the array is the most recent commit.
  const lastSHA1 = lastGitRef?.objectId;

  if (lastSHA1 === undefined || lastSHA1 === "") {
    azureDevOpsError(
      "Failed to find the latest commit from the master branch.",
    );
  }

  return lastSHA1;
}

async function getMostRecentCommitSHA1OnPR(
  gitAPI: IGitApi,
  projectID: string,
  repositoryID: string,
  pullRequestID: number,
): Promise<string> {
  // `gitAPI.getPullRequestById` returns an object with `commits` equal to undefined. Thus, we have
  // to perform a separate API call. We can't use "getRefs" like in the
  // "getMostRecentCommitSHA1OnMaster" function since that fails with the pull request branch name.
  const gitCommitRefs = await gitAPI.getPullRequestCommits(
    repositoryID,
    pullRequestID,
    projectID,
  );

  const lastGitRef = gitCommitRefs[0]; // The first commit in the array is the most recent commit.
  const lastSHA1 = lastGitRef?.commitId;

  if (lastSHA1 === undefined || lastSHA1 === "") {
    azureDevOpsError(
      `Failed to find the last commit corresponding to pull request: ${pullRequestID}`,
    );
  }

  return lastSHA1;
}

export async function getLastCommitMessage(
  gitAPI: IGitApi,
  projectID: string,
  repositoryID: string,
): Promise<string> {
  const lastCommit = await getLastCommit(gitAPI, projectID, repositoryID);
  const { comment } = lastCommit;
  if (comment === undefined || comment === "") {
    azureDevOpsError(
      `Failed to get the comment from the last commit of repository ID: ${repositoryID}`,
    );
  }

  return comment;
}

async function getLastCommit(
  gitAPI: IGitApi,
  projectID: string,
  repositoryID: string,
): Promise<GitCommitRef> {
  const commits = await gitAPI.getCommits(
    repositoryID,
    {
      $top: 1, // Only get the most recent commit
    },
    projectID,
  );

  const lastCommit = commits[0];
  assertDefined(
    lastCommit,
    `Failed to retrieve the last commit for repository ID: ${repositoryID}`,
  );

  return lastCommit;
}

/**
 * There is no built-in API function to do this.
 *
 * @returns Whether the deletion was successful.
 * @see https://github.com/microsoft/azure-devops-node-api/issues/259
 */
export async function deleteBranch(
  gitAPI: IGitApi,
  projectID: string,
  repositoryID: string,
  branchName: string,
): Promise<boolean> {
  const gitRefs = await gitAPI.getRefs(repositoryID, projectID);

  // There should only be one ref with a name that corresponds to the branch.
  const branchGitRef = gitRefs.find(
    (ref) => ref.name === `refs/heads/${branchName}`,
  );
  if (branchGitRef === undefined) {
    azureDevOpsError(
      `Failed to find the Git ref corresponding to branch "${branchName}" for repository ID "${repositoryID}".`,
    );
  }

  const objectID = branchGitRef.objectId;
  if (objectID === undefined) {
    azureDevOpsError(
      `Failed to find the object ID corresponding to branch "${branchName}" for repository ID "${repositoryID}`,
    );
  }

  const gitRefUpdate: GitRefUpdate = {
    name: `refs/heads/${branchName}`,
    oldObjectId: objectID,
    newObjectId: "0000000000000000000000000000000000000000", // See above linked GitHub issue.
    repositoryId: repositoryID,
  };

  const results = await gitAPI.updateRefs(
    [gitRefUpdate],
    repositoryID,
    projectID,
  );
  return results.every((result) => result.success === true);
}

/**
 * Helper function to display an error on the Azure DevOps GUI (using the special `##vso` syntax)
 * and exit the program.
 */
export function azureDevOpsError(msg: string): never {
  const fullMsg = `${msg}\n\n(Please contact James Nesta if you believe that this pipeline is bugged.)`;

  // https://stackoverflow.com/questions/61814674/filetransform-task-escapes-newline-during-azure-pipeline-task
  const msgWithoutNewlines = fullMsg.replaceAll("\n", "%0A");

  console.log(`##vso[task.logissue type=error]${msgWithoutNewlines}`);
  console.log("##vso[task.complete result=Failed;]");
  process.exit();
}
