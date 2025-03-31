# Containers

This directory contains the source code for containers that are used to host services internally for the company. (External-facing services typically are hosted on Windows virtual machines using IIS.)

## Upload/Push to the Azure Container Registry

Container images are hosted in the "lhinfra.azurecr.io" Azure container registry. They are not automatically updated when container source code is updated on `master`. Thus, if you update a container's source code, you must manually push a new version to the registry. Examples for how to do this are contained within the "build.sh" scripts.
