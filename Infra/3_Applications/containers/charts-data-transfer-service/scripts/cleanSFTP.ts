// This is a script to delete form files older than a certain date on the remote SFTP server.
// Because it does not interact with the file system of "BEDPFEPM002", it can be executed on any
// server.

/* eslint-disable @typescript-eslint/no-restricted-imports */

import { sleep } from "complete-node";
import type { queueAsPromised } from "fastq";
import fastq from "fastq";
import type SSH2SFTPClient from "ssh2-sftp-client";
import {
  getDateFromDirectoryName,
  isDateValid,
} from "../src/getFilePathsToUpload.js";
import { getSFTPClient } from "../src/sftp.js";

interface Task {
  sftpClient: SSH2SFTPClient;
  filePath: string;
}

/** Setting this to 10 or higher gives an error from Node. */
const NUM_QUEUE_ELEMENTS = 9;

const queue1: queueAsPromised<Task, void> = fastq.promise(
  getOldDirectoryPaths,
  NUM_QUEUE_ELEMENTS,
);

const queue2: queueAsPromised<Task, void> = fastq.promise(
  deleteSFTPDirectory,
  NUM_QUEUE_ELEMENTS,
);

const directoryPathsToDelete: string[] = [];

await main();

async function main() {
  const sftpClient1 = await getSFTPClient();
  await queue1.push({
    sftpClient: sftpClient1,
    filePath: "/claims/inbound-smb",
  });

  await sleep(1);

  while (queue1.length() > 0) {
    // eslint-disable-next-line no-await-in-loop
    await sleep(0);
  }

  console.log(
    `Found ${directoryPathsToDelete.length} old directories to delete.`,
  );

  if (directoryPathsToDelete.length === 0) {
    process.exit();
  }

  const sftpClient2 = await getSFTPClient();
  for (const directoryPath of directoryPathsToDelete) {
    // eslint-disable-next-line @typescript-eslint/no-floating-promises
    queue2.push({
      sftpClient: sftpClient2,
      filePath: directoryPath,
    });
  }

  await sleep(1);

  while (queue2.length() > 0) {
    // eslint-disable-next-line no-await-in-loop
    await sleep(0);
  }

  console.log("Completed.");
  process.exit();
}

async function getOldDirectoryPaths(task: Task): Promise<void> {
  const { sftpClient, filePath } = task;

  console.log("Searching directory:", filePath);
  const fileInfos = await sftpClient.list(filePath);

  for (const fileInfo of fileInfos) {
    const fullFilePath =
      filePath === "/" ? `/${fileInfo.name}` : `${filePath}/${fileInfo.name}`;

    if (fileInfo.type !== "d") {
      continue;
    }

    // Do not search through directories that match the format: 20240101
    const date = getDateFromDirectoryName(fileInfo.name);
    if (date === undefined) {
      // eslint-disable-next-line @typescript-eslint/no-floating-promises
      queue1.push({
        sftpClient,
        filePath: fullFilePath,
      });
    } else if (!isDateValid(date)) {
      directoryPathsToDelete.push(fullFilePath);
    }
  }
}

async function deleteSFTPDirectory(task: Task) {
  const { sftpClient, filePath } = task;

  try {
    await sftpClient.rmdir(filePath, true);
  } catch {
    return;
  }
  console.log("Deleted:", filePath);
}
