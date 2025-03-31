#!/bin/bash

set -euo pipefail # Exit on errors and undefined variables.

if ! podman machine ls | grep podman-machine-default | grep "Currently running"; then
  podman machine start
fi

# Confirm that the Azure CLI is currently logged in.
AZURE_CONTAINER_REGISTRY_NAME="lhinfra"
echo "Checking to see if we can login to Azure container registry of: $AZURE_CONTAINER_REGISTRY_NAME"
echo "(If this fails, run \"az login\" and then execute this script again.)"
az acr login --name "$AZURE_CONTAINER_REGISTRY_NAME"

# Build the container image. We use the "podman" command to do this.
# We could also build and publish in one step using the "az acr build". However, this is buggy:
# - It uses an older version of Docker that does not have modern syntax (like `COPY --chmod`).
# - It does not automatically recognize "Containerfile" or ".containerignore" files.
# - It does not properly cache each build step.
CONTAINER_NAME=$(basename $PWD)
podman build --tag "$CONTAINER_NAME" .

# Upload it to the remote registry in Azure.
CONTAINER_VERSION=$(cat version.txt)
podman tag "localhost/$CONTAINER_NAME:latest" "$AZURE_CONTAINER_REGISTRY_NAME.azurecr.io/$CONTAINER_NAME:$CONTAINER_VERSION"
podman push "$AZURE_CONTAINER_REGISTRY_NAME.azurecr.io/$CONTAINER_NAME:$CONTAINER_VERSION"
