import { ClientSecretCredential } from "@azure/identity";
import { SecretClient } from "@azure/keyvault-secrets";
import { assertDefined } from "complete-common";
import { env } from "./env.js";

const AZURE_KEY_VAULT_NAME = "lh-kv-chartsdat-eus-prod";
const AZURE_KEY_VAULT_URL = `https://${AZURE_KEY_VAULT_NAME}.vault.azure.net/`;

/** This corresponds to the "Application (client) ID" in the GUI for: sp-lh-kv-chartsdat-eus-prod */
const APPLICATION_CLIENT_ID = "599cfce1-765a-40a3-baf6-108caabf74e2";

/** This corresponds to the "Directory (tenant) ID" in the GUI for: sp-lh-kv-chartsdat-eus-prod */
const TENANT_ID = "54ba6692-0195-4329-9a5d-08a427817083";

const credential = new ClientSecretCredential(
  TENANT_ID,
  APPLICATION_CLIENT_ID,
  env.APPLICATION_CLIENT_SECRET,
);
const secretClient = new SecretClient(AZURE_KEY_VAULT_URL, credential);

/**
 * Helper function to get a secret from an Azure Key Vault. Will throw an error if the provided
 * secret name cannot be found in the key vault.
 */
export async function getAzureKeyVaultSecret(
  secretName: string,
): Promise<string> {
  const secret = await secretClient.getSecret(secretName);
  const { value } = secret;

  assertDefined(
    value,
    `Failed to get a secret from the Azure Key Vault of "${AZURE_KEY_VAULT_NAME}" with a name of: ${secretName}`,
  );

  return value;
}
