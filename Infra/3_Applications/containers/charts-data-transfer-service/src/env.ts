import { getEnv } from "complete-node";
import { z } from "zod";

const envSchema = z.object({
  /** For the "sp-lh-kv-chartsdat-eus-prod" service principal. */
  APPLICATION_CLIENT_SECRET: z.string().min(1),
});

/**
 * If this application is running on Windows, assume that we are running a script from a development
 * laptop. In this case, we want to use the ".env" file to get the environment variables. (In
 * production, this application will be running inside of a container and the environment variables
 * will already be injected into the container.)
 */
export const env =
  process.platform === "win32"
    ? getEnv(envSchema)
    : envSchema.parse(process.env);
