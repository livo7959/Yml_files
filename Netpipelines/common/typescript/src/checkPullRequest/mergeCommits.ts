import type { IGitApi } from "azure-devops-node-api/GitApi.js";
import type { GitCommit } from "azure-devops-node-api/interfaces/GitInterfaces.js";
import { filterMap } from "complete-common";
import { azureDevOpsError } from "../azureDevOps.js";

export async function checkMergeCommits(
  gitAPI: IGitApi,
  repositoryID: string,
  pullRequestID: number,
): Promise<void> {
  const mergeCommits = await getMergeCommits(
    gitAPI,
    repositoryID,
    pullRequestID,
  );

  if (mergeCommits.length > 0) {
    console.log("Merge commits found:");
    console.log(mergeCommits);
    azureDevOpsError(
      "Your pull request contains one or more merge commits, which is against company policy. (You can get more details by clicking on this error message and reviewing the job output.) To fix this problem, either force push to your branch to remove the merge commits, or start a new branch based off the master branch and reapply your changes. In the future, please rebase your feature branches on master instead of merging in order to avoid this problem.",
    );
  }
}

async function getMergeCommits(
  gitAPI: IGitApi,
  repositoryID: string,
  pullRequestID: number,
): Promise<readonly GitCommit[]> {
  // `gitAPI.getPullRequestById` returns an object with `commits` equal to undefined. Thus, we have
  // to perform a separate API call to get the commits.
  const gitCommitRefs = await gitAPI.getPullRequestCommits(
    repositoryID,
    pullRequestID,
  );

  // `gitCommitRef.parents` is equal to undefined at this point, so we have to perform a separate
  // API call to get the commit details.
  const commitIDs = filterMap(
    gitCommitRefs,
    (gitCommitRef) => gitCommitRef.commitId,
  );
  const gitCommitPromises = commitIDs.map(async (commitID) =>
    gitAPI.getCommit(commitID, repositoryID),
  );
  const gitCommits = await Promise.all(gitCommitPromises);

  return gitCommits.filter(
    (gitCommit) =>
      gitCommit.parents !== undefined && gitCommit.parents.length > 1,
  );
}
