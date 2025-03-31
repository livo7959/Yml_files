import { sleep } from "complete-node";
import { initDatabase } from "./database.js";
import { getFilePathsToUpload } from "./getFilePathsToUpload.js";
import { log } from "./logger.js";
import { uploadFilesToSFTP } from "./sftp.js";

await main();

async function main() {
  initDatabase();

  // Run forever, scanning for files and then uploading them.
  // eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
  while (true) {
    try {
      log("Finding files to upload...");
      const filePathsToUpload = await getFilePathsToUpload(); // eslint-disable-line no-await-in-loop
      log(`${filePathsToUpload.length} files found.`);
      if (filePathsToUpload.length > 0) {
        await uploadFilesToSFTP(filePathsToUpload); // eslint-disable-line no-await-in-loop
      }
      await sleep(1); // eslint-disable-line no-await-in-loop
    } catch (error) {
      const errorText =
        error instanceof Error
          ? `${error.message}\nStack: ${error.stack}`
          : error;
      log(`Encountered an error in the main loop: ${errorText}`);
    }
  }
}
