// This is a script to delete empty directories on the remote SFTP server. Because it does not
// interact with the local file system, it can be executed on any server (not just the "BEDPFEPM002"
// VM).

/* eslint-disable @typescript-eslint/no-restricted-imports */

import { sleep } from "complete-node";
import type { queueAsPromised } from "fastq";
import fastq from "fastq";
import path from "node:path";
import type SSH2SFTPClient from "ssh2-sftp-client";
import { getDateFromDirectoryName } from "../src/getFilePathsToUpload.js";
import { getSFTPClient } from "../src/sftp.js";

interface Task {
  sftpClient: SSH2SFTPClient;
  filePath: string;
}

/** Setting this to 10 or higher gives an error from Node. */
const NUM_QUEUE_ELEMENTS = 9;

const queue1: queueAsPromised<Task, void> = fastq.promise(
  getEmptyDirectoryPaths,
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
    `Found ${directoryPathsToDelete.length} empty directories to delete.`,
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

async function getEmptyDirectoryPaths(task: Task): Promise<void> {
  const { sftpClient, filePath } = task;

  const fileInfos = await sftpClient.list(filePath);

  if (fileInfos.length === 0) {
    const directoryName = path.basename(filePath);
    const date = getDateFromDirectoryName(directoryName);
    if (date !== undefined) {
      console.log(`Empty directory found: ${filePath}`);
      directoryPathsToDelete.push(filePath);
    }
  } else {
    for (const fileInfo of fileInfos) {
      if (fileInfo.type !== "d") {
        continue;
      }

      const fullFilePath =
        filePath === "/" ? `/${fileInfo.name}` : `${filePath}/${fileInfo.name}`;

      // eslint-disable-next-line @typescript-eslint/no-floating-promises
      queue1.push({
        sftpClient,
        filePath: fullFilePath,
      });
    }
  }
}

async function deleteSFTPDirectory(task: Task) {
  const { sftpClient, filePath } = task;
  await sftpClient.rmdir(filePath, true);
  console.log("Deleted:", filePath);
}
