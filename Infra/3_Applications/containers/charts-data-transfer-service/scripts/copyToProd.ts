// Normally, we would deploy the microservice code to via Git by running a `git pull` on the
// "BEDPFEPM002" server. (This is the server that runs AllScripts.) However, on November 16th, Git
// operations hanged and maxed out the CPU on the virtual machine, causing an AllScripts outage. The
// system is running Microsoft Windows Server 2019 Datacenter, so it is considered to be legacy.
// Once it is upgraded to a modern operating system, I expect `git` functionality to work as
// expected. In the meantime, we revert to deploying the microservice code by sharing the
// "C:\_IT\charts-data-transfer-service" directory with access to specific administrators and then
// manually copying the files in place by mapping a shared drive and running this script.

import { copyFileOrDirectory, getFilePathsInDirectory } from "complete-node";
import path from "node:path";

const MAPPED_DRIVE_LETTER = "y";
const REPO_ROOT = path.join(import.meta.dirname, "..");

main();

function main() {
  const filePaths = getFilePathsInDirectory(REPO_ROOT);
  for (const filePath of filePaths) {
    const fileName = path.basename(filePath);
    if (fileName === "node_modules" || fileName === "dist") {
      continue;
    }

    const relativePath = path.relative(REPO_ROOT, filePath);
    const dstPath = path.join(`${MAPPED_DRIVE_LETTER}:\\`, relativePath);
    copyFileOrDirectory(filePath, dstPath);
    console.log(`Copied: ${dstPath}`);
  }
}
