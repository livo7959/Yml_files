import { $, isFile } from "complete-node";
import path from "node:path";
import { MONOREPO_ROOT } from "../constants.js";

// Define the new location of the .sqlfluff file
const SQLFLUFF_CONFIG_PATH = path.join(MONOREPO_ROOT, ".sqlfluff");

/** We use the SQLFluff tool to lint SQL files, including custom rules. */
export async function lintSQL(
  changedFilePaths: readonly string[],
): Promise<void> {
  // Filter for .sql files
  const sqlFilePaths = changedFilePaths.filter((filePath) =>
    filePath.endsWith(".sql"),
  );

  if (sqlFilePaths.length === 0) {
    console.log("No SQL files to lint.");
    return;
  }

  // Construct full paths
  const fullFilePaths = sqlFilePaths.map((sqlFilePath) =>
    path.join(MONOREPO_ROOT, sqlFilePath),
  );

  // Filter for files that still exist
  const existingFiles = fullFilePaths.filter(isFile);

  if (existingFiles.length === 0) {
    console.log("No existing SQL files to lint.");
    return;
  }

  try {
    // Lint each file using SQLFluff
    await Promise.all(
      existingFiles.map(async (fullFilePath) => {
        console.log(`Linting file: ${fullFilePath}`);
        await $`sqlfluff lint --nofail --dialect tsql --config ${SQLFLUFF_CONFIG_PATH} ${fullFilePath}`;
      }),
    );
    console.log("SQL linting completed successfully.");
  } catch (error) {
    console.error("Error during SQL linting:", error);
    throw error;
  }
}
