import transliterate from "@sindresorhus/transliterate";
import type { queueAsPromised } from "fastq";
import fastq from "fastq";
import path from "node:path";
import SSH2SFTPClient from "ssh2-sftp-client";
import { getAzureKeyVaultSecret } from "./azureKeyVault.js";
import { addFilePathToDatabase } from "./database.js";
import { FILE_ROOT } from "./getFilePathsToUpload.js";
import { log } from "./logger.js";

interface Task {
  sftpClient: SSH2SFTPClient;
  filePath: string;
  currentNum: number;
  totalNum: number;
}

const SFTP_HOST = "lhdatalakestoragestg.blob.core.windows.net";
const SFTP_USERNAME =
  "lhdatalakestoragestg.uploaded-data.chartsdatatransferservice";
const SFTP_PRIVATE_KEY = await getAzureKeyVaultSecret("ssh-key");

/**
 * Integrator uploads files to "/claims/inbound", so we want to use a different directory to
 * distinguish between the different sources.
 */
const SFTP_PATH_PREFIX = "/claims/inbound-smb";

/**
 * - Setting this to 5 results in around 7-8 uploaded files per second.
 * - Setting this to 10 results in around 9-10 uploaded files per second.
 * - Increasing this past 10 does not result in further benefits.
 */
const NUM_FILES_TO_CONCURRENTLY_UPLOAD = 10;

const queue: queueAsPromised<Task, void> = fastq.promise(
  uploadFileToSFTP,
  NUM_FILES_TO_CONCURRENTLY_UPLOAD,
);

export async function getSFTPClient(): Promise<SSH2SFTPClient> {
  /** @see https://github.com/theophilusx/ssh2-sftp-client */
  const sftpClient = new SSH2SFTPClient();
  await sftpClient.connect({
    host: SFTP_HOST,
    username: SFTP_USERNAME,
    privateKey: SFTP_PRIVATE_KEY,
  });

  log(`Connected to: ${SFTP_HOST}`);

  return sftpClient;
}

/**
 * We re-connect to the SFTP server each time because the connection can get stale and cause an
 * error of: lstat: No SFTP connection available
 */
export async function uploadFilesToSFTP(
  filePathsToUpload: readonly string[],
): Promise<void> {
  const sftpClient = await getSFTPClient();

  const promises: Array<Promise<void>> = [];
  for (const [i, filePath] of filePathsToUpload.entries()) {
    const promise = queue.push({
      sftpClient,
      filePath,
      currentNum: i + 1,
      totalNum: filePathsToUpload.length,
    });
    promises.push(promise);
  }

  await Promise.all(promises);
}

async function uploadFileToSFTP(task: Task) {
  const { sftpClient, filePath, currentNum, totalNum } = task;

  const strippedFilePath = path.relative(FILE_ROOT, filePath); // Remove the mount root prefix.
  const partialSFTPPath = convertWindowsPathToSFTPPath(strippedFilePath);
  const sftpPath = path.join(SFTP_PATH_PREFIX, partialSFTPPath);
  const exists = await sftpClient.exists(sftpPath);
  if (exists !== false) {
    addFilePathToDatabase(filePath);
    log(`This file path already exists: ${filePath}`);
    return;
  }

  // If the parent directory does not exist, we must first create it, or else the upload will fail.
  try {
    const parentDirectory = path.dirname(sftpPath);
    await sftpClient.mkdir(parentDirectory, true);
    log(`Created: ${parentDirectory}`);
  } catch {
    // This might fail if the directory already exists. Because multiple versions of this function
    // may be running in parallel, errors are expected, so we ignore them.
  }

  await sftpClient.put(filePath, sftpPath);
  addFilePathToDatabase(filePath);
  const percentComplete = Math.round((currentNum / totalNum) * 100);
  log(
    `Uploaded: ${sftpPath} (${currentNum} / ${totalNum}, ${percentComplete}%)`,
  );
}

function convertWindowsPathToSFTPPath(string: string): string {
  return (
    // Handle non-ASCII characters.
    // https://github.com/sindresorhus/transliterate
    transliterate(string)
      .toLowerCase()
      .replaceAll("\\", "/")
      .replaceAll(" ", "-")
      // Remove all characters that are not numbers, periods, forward slashes, letters, or hyphens.
      .replaceAll(/[^\d./A-Za-z-]+/g, "")
      // Replace two or more subsequent hyphens with one hyphen.
      .replaceAll(/--+/g, "-")
  );
}
