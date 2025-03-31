import { z } from "zod";

const envSchema = z.object({
  /** For the "sp-lh-kv-autocompl-eus-prod" service principal. */
  APPLICATION_CLIENT_SECRET: z.string().min(1),
});

export const env = envSchema.parse(process.env);
