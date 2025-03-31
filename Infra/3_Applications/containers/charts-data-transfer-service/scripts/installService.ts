// We use the "node-windows" package to automatically install a Windows service:
// https://coreybutler.github.io/node-windows/manual/#!/guide/nodeWindowsService

import { $s, getPackageJSON } from "complete-node";
import nodeWindows from "node-windows";
import path from "node:path";

const packageJSONPath = path.join(import.meta.dirname, "..", "package.json");
const { name, description } = getPackageJSON(packageJSONPath);

if (typeof name !== "string") {
  throw new TypeError(
    `Failed to get the "name" field from: ${packageJSONPath}`,
  );
}

if (typeof description !== "string") {
  throw new TypeError(
    `Failed to get the "description" field from: ${packageJSONPath}`,
  );
}

// Ensure that the program is compiled.
$s`npm run build`;

const script = path.join(import.meta.dirname, "..", "dist", "main.js");
const service = new nodeWindows.Service({
  name,
  description,
  script,
});

// Listen for the "install" event, which indicates the process is available as a service.
service.on("install", () => {
  service.start();
});

service.install();
