#!/bin/bash

set -euo pipefail # Exit on errors and undefined variables.

# This corresponds to the "Application (client) ID" in the GUI for: sp-lh-kv-docs-eus-prod
APPLICATION_CLIENT_ID="4882ed78-fc76-4411-bd14-6f31f31700e8"

if [[ -z ${APPLICATION_CLIENT_SECRET-} ]]; then
  echo "Failed to get secrets from Azure Key Vault since the \"APPLICATION_CLIENT_SECRET\" environment variable is unset."
  exit 1
fi

# This corresponds to the "Directory (tenant) ID" in the GUI for: sp-lh-kv-docs-eus-prod
TENANT_ID="54ba6692-0195-4329-9a5d-08a427817083"

# Get the "docs.logixhealth.com.key" file from Azure Key Vault.
az login \
  --service-principal \
  --username "$APPLICATION_CLIENT_ID" \
  --password "$APPLICATION_CLIENT_SECRET" \
  --tenant "$TENANT_ID"
CERT_KEY_PATH="/etc/nginx/certs/docs.logixhealth.com.key"
az keyvault secret show --vault-name "lh-kv-docs-eus-prod" --name "cert-key" --query "value" --output "tsv" > "$CERT_KEY_PATH"
chmod 600 "$CERT_KEY_PATH"

# Test the nginx config so that we can fail early.
nginx -t

# Get the Azure DevOps personal access token, which is used to clone the repository.
export AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN=$(az keyvault secret show --vault-name "lh-kv-docs-eus-prod" --name "http-auth-password" --query "value" --output "tsv")

# Build the Docusaurus website for the first time.
bash /build-website.sh

# Launch the webhook listener before launching nginx.
node /webhook-listener/dist/main.js &

# Call the original nginx entrypoint. We have to explicitly pass the default "CMD" parameters,
# since they will not be automatically inherited after the entrypoint is changed:
# https://github.com/nginxinc/docker-nginx/blob/master/Dockerfile-debian.template
exec /docker-entrypoint.sh nginx -g 'daemon off;'
