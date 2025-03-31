import { includes, parseIntSafe } from "complete-common";
import { getFilePathsInDirectoryAsync, isDirectory } from "complete-node";
import path from "node:path";
import { uploadedFiles } from "./database.js";

interface Date {
  year: number;
  month: number;
  day: number;
}

/**
 * This is the path to the SMB file share. (The files live on the "BEDPFEPM002" virtual machine.)
 */
export const FILE_ROOT = "/ntierfiles";

const FORM_DIRECTORIES = ["277A", "277P", "277U"] as const;

/** Directory names are in the format of: 20231129 */
const DATE_DIRECTORY_REGEX = /(\d{4})(\d{2})(\d{2})/;

/** e.g. E:\NtierFiles */
export async function getFilePathsToUpload(): Promise<readonly string[]> {
  const companyDirectories = await getFilePathsInDirectoryAsync(
    FILE_ROOT,
    "directories",
  );
  const filesToUploadArray = await Promise.all(
    companyDirectories.map(async (companyDirectory) =>
      getFilesToUploadFromCompanyDirectory(companyDirectory),
    ),
  );

  return filesToUploadArray.flat();
}

/** e.g. E:\NtierFiles\24x7 Emergency Care */
async function getFilesToUploadFromCompanyDirectory(
  companyDirectory: string,
): Promise<readonly string[]> {
  const subdirectories = await getFilePathsInDirectoryAsync(
    companyDirectory,
    "directories",
  );
  const formDirectories = subdirectories.filter((subdirectory) => {
    const directoryName = path.basename(subdirectory);
    return includes(FORM_DIRECTORIES, directoryName);
  });

  const filesToUploadArray = await Promise.all(
    formDirectories.map(async (formDirectory) =>
      getFilesToUploadFromFormDirectory(formDirectory),
    ),
  );

  return filesToUploadArray.flat();
}

/** e.g. E:\NtierFiles\24x7 Emergency Care\277A */
async function getFilesToUploadFromFormDirectory(
  formDirectory: string,
): Promise<readonly string[]> {
  const processedDirectory = path.join(formDirectory, "processed");
  if (!isDirectory(processedDirectory)) {
    return [];
  }

  const dateDirectories = await getFilePathsInDirectoryAsync(
    processedDirectory,
    "directories",
  );

  const filesToUploadArray = await Promise.all(
    dateDirectories.map(async (dateDirectory) =>
      getFilesToUploadFromDateDirectory(dateDirectory),
    ),
  );

  return filesToUploadArray.flat();
}

/** e.g. E:\NtierFiles\24x7 Emergency Care\277A\processed\20231024 */
async function getFilesToUploadFromDateDirectory(
  formDirectory: string,
): Promise<readonly string[]> {
  const filePaths = await getFilePathsInDirectoryAsync(formDirectory, "files");

  return filePaths.filter((filePath) => {
    if (uploadedFiles.has(filePath)) {
      return false;
    }

    const directoryName = path.basename(filePath);
    const date = getDateFromDirectoryName(directoryName);
    if (date === undefined) {
      return false;
    }

    return isDateValid(date);
  });
}

export function getDateFromDirectoryName(
  directoryName: string,
): Date | undefined {
  const match = directoryName.match(DATE_DIRECTORY_REGEX);
  if (match === null) {
    return undefined;
  }

  const yearString = match[1];
  const monthString = match[2];
  const dayString = match[3];

  if (
    yearString === undefined ||
    monthString === undefined ||
    dayString === undefined
  ) {
    return undefined;
  }

  const year = parseIntSafe(yearString);
  const month = parseIntSafe(monthString);
  const day = parseIntSafe(dayString);

  if (year === undefined || month === undefined || day === undefined) {
    return undefined;
  }

  return {
    year,
    month,
    day,
  };
}

/** Do not bother uploading files that are older than December 1st, 2024. */
export function isDateValid(date: Date): boolean {
  const { year, month } = date;
  return year > 2024 || (year === 2024 && month >= 12);
}
