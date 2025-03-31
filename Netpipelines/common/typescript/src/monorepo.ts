// Functions that contain logic relating to the LogixApplications monorepo.

import type { GitPullRequest } from "azure-devops-node-api/interfaces/GitInterfaces.js";
import { trimPrefix, trimSuffix } from "complete-common";
import { azureDevOpsError } from "./azureDevOps.js";

export function getAppNameForPR(changedFilePaths: readonly string[]): string {
  const potentialAppName = getAppNameFromFilePaths(changedFilePaths);

  // Use a default name if this pull request only touches files outside of an official application
  // directory.
  const appName = potentialAppName ?? "misc";
  console.log(`Detected an application name of: ${appName}`);

  return appName;
}

/**
 * If multiple applications are changed, this function will only return the name of the first one.
 */
function getAppNameFromFilePaths(
  filePaths: readonly string[],
): string | undefined {
  for (const filePath of filePaths) {
    const matchAppsMVC = filePath.match(/^\/apps\/mvc\/(\w+)$/);
    if (matchAppsMVC !== null) {
      const appName = matchAppsMVC[1];
      if (appName !== undefined) {
        return appName;
      }
    }

    const matchTest = filePath.match(/^\/test\/automation.Net\/(\w+)$/);
    if (matchTest !== null) {
      const appName = matchTest[1];
      if (appName !== undefined) {
        return appName;
      }
    }

    const matchCICD = filePath.match(/^\/ci_cd\/(\w+)$/);
    if (matchCICD !== null) {
      const appName = matchCICD[1];
      if (appName !== undefined) {
        return appName;
      }
    }

    const matchPlatform = filePath.match(
      /^\/platform\/API\/ApplicationServices\/(\w+)$/,
    );
    if (matchPlatform !== null) {
      const appName = matchPlatform[1];
      if (appName !== undefined) {
        return trimSuffix(appName, "Services");
      }
    }
  }

  return undefined;
}

export function getUsernameOfPRAuthor(pullRequest: GitPullRequest): string {
  if (
    pullRequest.createdBy === undefined ||
    pullRequest.createdBy.uniqueName === undefined ||
    pullRequest.createdBy.uniqueName === ""
  ) {
    azureDevOpsError("Failed to find who the pull request was created by.");
  }

  // This will be something like: CORP\jnesta
  if (!pullRequest.createdBy.uniqueName.startsWith("CORP\\")) {
    azureDevOpsError(
      `The pull request does not come from a corporate account and instead comes from: ${pullRequest.createdBy.uniqueName}`,
    );
  }

  return trimPrefix(pullRequest.createdBy.uniqueName, "CORP\\");
}
