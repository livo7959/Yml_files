import { $, lintScript } from "complete-node";

await lintScript(async () => {
  await Promise.all([
    // Use TypeScript to type-check the code.
    $`tsc --noEmit`,
    $`tsc --noEmit --project ./scripts/tsconfig.json`,

    // Use ESLint to lint the TypeScript code.
    // - "--max-warnings 0" makes warnings fail, since we set all ESLint errors to warnings.
    $`eslint --max-warnings 0 .`,

    // Use Prettier to check formatting.
    // - "--log-level=warn" makes it only output errors.
    $`prettier --log-level=warn --check --ignore-path=../../../.prettierignore .`,

    // Use Knip to check for unused files, exports, and dependencies.
    $`knip --no-progress`,
  ]);
});
