import { fastifyBasicAuth } from "@fastify/basic-auth";
import { isObject } from "complete-common";
import { getPackageJSONFieldMandatory, readFile } from "complete-node";
import { fastify } from "fastify";
import path from "node:path";
import { setAutoCompleteForPullRequest } from "./azureDevOps.js";
import { getAzureKeyVaultSecret } from "./azureKeyVault.js";

const HTTP_AUTH_PASSWORD = await getAzureKeyVaultSecret("http-auth-password");

await main();

async function main() {
  const packageJSONPath = path.join(import.meta.dirname, "..", "package.json");
  const name = getPackageJSONFieldMandatory(packageJSONPath, "name");

  // TODO: Set up Application Insights resource + enable authenticate for it + see if it works with
  // Pino.
  /// applicationinsights.setup(env.AZURE_APP_INSIGHTS_CONNECTION_STRING).start();

  const certPath = path.join(
    import.meta.dirname,
    "..",
    "certs",
    "auto-auto-complete.logixhealth.com.fullchain.crt",
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
        username === name && password === HTTP_AUTH_PASSWORD;
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
  httpServer.post("/pull-request-created", (request, reply) => {
    console.log("Got webhook data:", request.body);
    const data = parseWebhookNotification(request.body);
    if (data !== undefined) {
      const { repositoryID, pullRequestID } = data;

      // We do not need to wait for the Azure DevOps API requests to complete before replying to the
      // webhook.
      // eslint-disable-next-line @typescript-eslint/no-floating-promises
      setAutoCompleteForPullRequest(repositoryID, pullRequestID);
    }

    return reply.send("success");
  });

  // Start the server.
  try {
    await httpServer.listen({
      host: "0.0.0.0",
      port: 8443, // The app user does not have permission to listen on port 443.
    });
  } catch (error) {
    httpServer.log.error(error, undefined, undefined);
  }
}

/** See below for an example of the body format. */
function parseWebhookNotification(body: unknown) {
  if (!isObject(body)) {
    throw new Error(
      "Failed to parse the HTTP request body since it was not an object.",
    );
  }

  const { eventType } = body;
  if (typeof eventType !== "string") {
    throw new TypeError(
      'Failed to parse the "eventType" since it was not a string.',
    );
  }

  if (eventType !== "git.pullrequest.created") {
    return undefined;
  }

  const { resource } = body;
  if (!isObject(resource)) {
    throw new Error(
      'Failed to parse the "resource" since it was not an object.',
    );
  }

  const { repository } = resource;
  if (!isObject(repository)) {
    throw new Error(
      'Failed to parse the "repository" since it was not an object.',
    );
  }

  const repositoryID = repository["id"];
  if (typeof repositoryID !== "string") {
    throw new TypeError(
      "Failed to parse the repository ID since it was not a string.",
    );
  }

  const pullRequestID = resource["pullRequestId"];
  if (typeof pullRequestID !== "number") {
    throw new TypeError(
      "Failed to parse the pull request ID since it was not a number.",
    );
  }

  return {
    repositoryID,
    pullRequestID,
  };
}

/*

Example of a PR creation from hitting the "Test" button in the Azure DevOps GUI:

{
  subscriptionId: '00000000-0000-0000-0000-000000000000',
  notificationId: 8,
  id: '2ab4e3d3-b7a6-425e-92b1-5a9982c1269e',
  eventType: 'git.pullrequest.created',
  publisherId: 'tfs',
  message: {
    text: 'Jamal Hartnett created a new pull request',
    html: 'Jamal Hartnett created a new pull request',
    markdown: 'Jamal Hartnett created a new pull request'
  },
  detailedMessage: {
    text: 'Jamal Hartnett created a new pull request\r\n' +
      '\r\n' +
      '- Merge status: Succeeded\r\n' +
      '- Merge commit: eef717(https://fabrikam.visualstudio.com/DefaultCollection/_apis/git/repositories/4bc14d40-c903-45e2-872e-0462c7748079/commits/eef717f69257a6333f221566c1c987dc94cc0d72)\r\n',
    html: 'Jamal Hartnett created a new pull request\r\n' +
      '<ul>\r\n' +
      '<li>Merge status: Succeeded</li>\r\n' +
      '<li>Merge commit: <a href="https://fabrikam.visualstudio.com/DefaultCollection/_apis/git/repositories/4bc14d40-c903-45e2-872e-0462c7748079/commits/eef717f69257a6333f221566c1c987dc94cc0d72">eef717</a></li>\r\n' +
      '</ul>',
    markdown: 'Jamal Hartnett created a new pull request\r\n' +
      '\r\n' +
      '+ Merge status: Succeeded\r\n' +
      '+ Merge commit: [eef717](https://fabrikam.visualstudio.com/DefaultCollection/_apis/git/repositories/4bc14d40-c903-45e2-872e-0462c7748079/commits/eef717f69257a6333f221566c1c987dc94cc0d72)\r\n'
  },
  resource: {
    repository: {
      id: '4bc14d40-c903-45e2-872e-0462c7748079',
      name: 'Fabrikam',
      url: 'https://fabrikam.visualstudio.com/DefaultCollection/_apis/git/repositories/4bc14d40-c903-45e2-872e-0462c7748079',
      project: [Object],
      defaultBranch: 'refs/heads/master',
      remoteUrl: 'https://fabrikam.visualstudio.com/DefaultCollection/_git/Fabrikam'
    },
    pullRequestId: 1,
    status: 'active',
    createdBy: {
      displayName: 'Jamal Hartnett',
      url: 'https://fabrikam.vssps.visualstudio.com/_apis/Identities/54d125f7-69f7-4191-904f-c5b96b6261c8',
      id: '54d125f7-69f7-4191-904f-c5b96b6261c8',
      uniqueName: 'fabrikamfiber4@hotmail.com',
      imageUrl: 'https://fabrikam.visualstudio.com/DefaultCollection/_api/_common/identityImage?id=54d125f7-69f7-4191-904f-c5b96b6261c8'
    },
    creationDate: '2014-06-17T16:55:46.589889Z',
    title: 'my first pull request',
    description: ' - test2\r\n',
    sourceRefName: 'refs/heads/mytopic',
    targetRefName: 'refs/heads/master',
    mergeStatus: 'succeeded',
    mergeId: 'a10bb228-6ba6-4362-abd7-49ea21333dbd',
    lastMergeSourceCommit: {
      commitId: '53d54ac915144006c2c9e90d2c7d3880920db49c',
      url: 'https://fabrikam.visualstudio.com/DefaultCollection/_apis/git/repositories/4bc14d40-c903-45e2-872e-0462c7748079/commits/53d54ac915144006c2c9e90d2c7d3880920db49c'
    },
    lastMergeTargetCommit: {
      commitId: 'a511f535b1ea495ee0c903badb68fbc83772c882',
      url: 'https://fabrikam.visualstudio.com/DefaultCollection/_apis/git/repositories/4bc14d40-c903-45e2-872e-0462c7748079/commits/a511f535b1ea495ee0c903badb68fbc83772c882'
    },
    lastMergeCommit: {
      commitId: 'eef717f69257a6333f221566c1c987dc94cc0d72',
      url: 'https://fabrikam.visualstudio.com/DefaultCollection/_apis/git/repositories/4bc14d40-c903-45e2-872e-0462c7748079/commits/eef717f69257a6333f221566c1c987dc94cc0d72'
    },
    reviewers: [ [Object] ],
    commits: [ [Object] ],
    url: 'https://fabrikam.visualstudio.com/DefaultCollection/_apis/git/repositories/4bc14d40-c903-45e2-872e-0462c7748079/pullRequests/1',
    _links: { web: [Object], statuses: [Object] }
  },
  resourceVersion: '1.0',
  resourceContainers: {
    collection: { id: 'c12d0eb8-e382-443b-9f9c-c52cba5014c2' },
    account: { id: 'f844ec47-a9db-4511-8281-8b63f4eaf94e' },
    project: { id: 'be9b3917-87e6-42a4-a549-2bc06a7a878f' }
  },
  createdDate: '2024-12-03T11:24:42.6229023Z'
}

*/
