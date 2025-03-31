import { TelemetryClient } from "applicationinsights";
import {
  getPackageJSONFieldMandatory,
  isDirectory,
  makeDirectory,
} from "complete-node";
import path from "node:path";
import winston from "winston";
import WinstonDailyRotateFile from "winston-daily-rotate-file";

/** For: charts-data-transfer-app */
const AZURE_APP_INSIGHTS_CONNECTION_STRING =
  "InstrumentationKey=7581ae14-342b-4372-85f9-61ecd96cc290;IngestionEndpoint=https://eastus-6.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus.livediagnostics.monitor.azure.com/;ApplicationId=e24c8e02-4dcb-4f6d-979c-7a1df8d69b07";

const REPO_ROOT = path.join(import.meta.dirname, "..");
const LOGS_DIRECTORY_PATH = path.join(REPO_ROOT, "logs");

if (!isDirectory(LOGS_DIRECTORY_PATH)) {
  makeDirectory(LOGS_DIRECTORY_PATH);
}

const packageJSONPath = path.join(import.meta.dirname, "..", "package.json");
const appName = getPackageJSONFieldMandatory(packageJSONPath, "name");

const logger = winston.createLogger({
  // By default, Winston does not include the timestamp in the log:
  // https://stackoverflow.com/questions/10271373/node-js-how-to-add-timestamp-to-logs-using-winston-library
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json(),
  ),

  transports: [
    new winston.transports.Console(),

    new WinstonDailyRotateFile({
      filename: `${appName}-%DATE%.log`,
      dirname: LOGS_DIRECTORY_PATH,
      zippedArchive: true,
      maxFiles: "90d",
    }),
  ],
});

const telemetryClient = new TelemetryClient(
  AZURE_APP_INSIGHTS_CONNECTION_STRING,
);

// eslint-disable-next-line complete/complete-sentences-jsdoc
/**
 * Log messages to:
 *
 * 1) the console
 * 2) to a flat file
 * 3) to Azure
 */
export function log(message: string): void {
  logger.info(message);
  telemetryClient.trackTrace({ message });
}
