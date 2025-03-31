import { isKebabCase } from "complete-common";
import { azureDevOpsError } from "../azureDevOps.js";

const WRONG_BRANCH_INSTRUCTIONS =
  "Please close/abandon this pull request, create a new branch with the correct name (using your old branch as a basis), and then submit a new pull request using the new branch.";

/** Delete this in the future when all applications are subject to the naming convention. */
const WHITELISTED_APPLICATION_NAMES: ReadonlySet<string> = new Set([
  "LogixConnect",
  "LogixFeedback",
  "LogixReconciler",
  "LogixReporting",
  "LogixRequest",
  "LogixStaffing",
  "LogixTraining",
  "website",
]);

export function checkBranchName(
  branchName: string,
  appName: string,
  username: string,
): void {
  // Only allow the branch name check to affect certain specific applications.
  if (!WHITELISTED_APPLICATION_NAMES.has(appName)) {
    console.log(
      `The app name of "${appName}" is not on the whitelist. Ignoring the branch name check.`,
    );
    return;
  }

  const regexString = `^feature/${appName}/${username}/(.+)$`;
  const regex = new RegExp(regexString);

  const match = branchName.match(regex);
  if (match === null) {
    azureDevOpsError(
      `This pull request was created from a branch named:\n\n${branchName}\n\nHowever, this does not match the company's naming convention of:\n\nfeature/${appName}/${username}/your-description-here\n\n${WRONG_BRANCH_INSTRUCTIONS}`,
    );
  }

  const description = match[1];
  if (description === undefined) {
    azureDevOpsError(
      `Failed to parse the description from the source branch name: ${branchName}`,
    );
  }

  if (/[A-Za-z]\d/.test(description)) {
    azureDevOpsError(
      `The final segment of your branch name is "${description}", but you must separate letters and numbers with a hyphen to match the kebab-case naming convention. ${WRONG_BRANCH_INSTRUCTIONS}`,
    );
  }

  if (!isKebabCase(description)) {
    azureDevOpsError(
      `The final segment of your branch name is "${description}", but this must be in kebab-case. ${WRONG_BRANCH_INSTRUCTIONS}`,
    );
  }

  console.log(
    `The branch name of "${branchName}" matches the company's naming convention.`,
  );
}
