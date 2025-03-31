#!/bin/bash

set -euo pipefail # Exit on errors and undefined variables.

# This corresponds to the "Application (client) ID" in the GUI for: sp-lh-kv-chartsdat-eus-prod
APPLICATION_CLIENT_ID="599cfce1-765a-40a3-baf6-108caabf74e2"

if [[ -z ${APPLICATION_CLIENT_SECRET-} ]]; then
  echo "Failed to get secrets from Azure Key Vault since the \"APPLICATION_CLIENT_SECRET\" environment variable is unset."
  exit 1
fi

# This corresponds to the "Directory (tenant) ID" in the GUI for: sp-lh-kv-chartsdat-eus-prod
TENANT_ID="54ba6692-0195-4329-9a5d-08a427817083"

# Get the SMB credentials file from Azure Key Vault.
SMB_USERNAME="svc_charts_data"
az login \
  --service-principal \
  --username "$APPLICATION_CLIENT_ID" \
  --password "$APPLICATION_CLIENT_SECRET" \
  --tenant "$TENANT_ID"
SMB_PASSWORD=$(az keyvault secret show --vault-name "lh-kv-chartsdat-eus-prod" --name "smb-password" --query "value" --output "tsv")

# Establish the SMB file share. ("10.10.33.52" corresponds to "BEDPFEPM002". We must specify the IP
# address because DNS does not work inside the container.)
mount --types cifs --source "//10.10.33.52/NtierFiles" --target "/ntierfiles" --options "username=$SMB_USERNAME,password=$SMB_PASSWORD"

# Keep the container running and switch to the "app" user.
exec setpriv --reuid=app --regid=app --init-groups "$@"
