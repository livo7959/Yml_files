import { appendFile, isFile, readFile, touch } from "complete-node";

const DATABASE_FILE_NAME = "uploaded-files.txt";

export const uploadedFiles = new Set<string>();

export function initDatabase(): void {
  if (!isFile(DATABASE_FILE_NAME)) {
    touch(DATABASE_FILE_NAME);
  }

  const uploadedFilesRaw = readFile(DATABASE_FILE_NAME);
  const uploadedFilesLines = uploadedFilesRaw.split("\n");
  for (const line of uploadedFilesLines) {
    uploadedFiles.add(line);
  }
}

/**
 * We keep the database both in memory (as a set) and on disk (as a text file with one line for each
 * file path entry).
 */
export function addFilePathToDatabase(filePath: string): void {
  uploadedFiles.add(filePath);
  appendFile(DATABASE_FILE_NAME, `${filePath}\n`);
}
