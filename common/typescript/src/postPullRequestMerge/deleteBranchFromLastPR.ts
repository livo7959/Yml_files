import type { IGitApi } from "azure-devops-node-api/GitApi.js";
import { deleteBranch } from "../azureDevOps.js";

export async function deleteBranchFromLastPR(
  gitAPI: IGitApi,
  projectID: string,
  repositoryID: string,
  branchName: string,
): Promise<void> {
  // Because the "checkPullRequest.ts" script checks the branch names of all incoming pull requests
  // to master, it should be impossible for the last pull request to come from a non-feature branch.
  // However, just in case, abort and do nothing for non-feature branches.
  if (!branchName.startsWith("feature/")) {
    return;
  }

  console.log(
    `Attempting to delete branch "${branchName}" on repository "${repositoryID}".`,
  );

  // Do not throw an error if deleting the branch was not successful, since the branch author may
  // have deleted the branch manually before this pipeline has had a chance to run.
  const success = await deleteBranch(
    gitAPI,
    projectID,
    repositoryID,
    branchName,
  );
  const msg = success
    ? `Deleted branch "${branchName}" for repository ID "${repositoryID}".`
    : `Failed to delete branch "${branchName}" for repository ID "${repositoryID}". (Perhaps it was already deleted?)`;
  console.log(msg);
}
