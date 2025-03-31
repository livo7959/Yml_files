import { fastifyBasicAuth } from "@fastify/basic-auth";
import { $, getPackageJSONFieldMandatory, readFile } from "complete-node";
import { fastify } from "fastify";
import path from "node:path";
import { getAzureKeyVaultSecret } from "./azureKeyVault.js";

const HTTP_AUTH_PASSWORD = await getAzureKeyVaultSecret("http-auth-password");

await main();

async function main() {
  const packageJSONPath = path.join(import.meta.dirname, "..", "package.json");
  const name = getPackageJSONFieldMandatory(packageJSONPath, "name");

  const certPath = path.join(
    import.meta.dirname,
    "..",
    "..",
    "certs",
    "docs.logixhealth.com.fullchain.crt",
  );
  const cert = readFile(certPath);
  const key = await getAzureKeyVaultSecret("cert-key");
  const httpServer = fastify({
    logger: true,
    https: {
      cert,
      key,
    },
  });

  // Set up authentication for all routes.
  // https://github.com/fastify/fastify-basic-auth

  await httpServer.register(fastifyBasicAuth, {
    validate: (username, password, _request, _reply, done) => {
      const authSuccessful =
        username === "azdo" && password === HTTP_AUTH_PASSWORD;
      if (authSuccessful) {
        done();
      } else {
        done(new Error("incorrect username or password"));
      }
    },
    authenticate: {
      realm: name,
    },
  });
  httpServer.addHook("onRequest", httpServer.basicAuth);

  // Set up routes.
  httpServer.post("/repo-pushed", (_request, reply) => {
    // We do not have to wait for the build script to complete before sending a response to the
    // client.
    // eslint-disable-next-line @typescript-eslint/no-floating-promises
    $`bash /docs-website/build.sh`;
    return reply.send("success");
  });

  // Start the server.
  try {
    await httpServer.listen({
      host: "0.0.0.0",
      port: 8443,
    });
  } catch (error) {
    httpServer.log.error(error, undefined, undefined);
  }
}
