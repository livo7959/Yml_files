#!/bin/bash

set -euo pipefail # Exit on errors and undefined variables.

REPOSITORY_URL="https://azuredevops.logixhealth.com/LogixHealth/Software%20Engineering/_git/LogixApplications"
SPARSE_PATH="ci_cd/common/typescript"
BRANCH_NAME="feature/jnesta/post-pull-request-merge"

if [[ -z ${AZDO_PERSONAL_ACCESS_TOKEN-} ]]; then
  echo "Failed to find the \"AZDO_PERSONAL_ACCESS_TOKEN\" secret in the \"ci_cd\" Azure DevOps library."
  exit 1
fi

BASE64_PAT=$(printf ":$AZDO_PERSONAL_ACCESS_TOKEN" | base64)

# "--config" is necessary to use the personal access token.
# "--no-checkout" means to not put anything in the working directory.
# "--no-tags" means to skip downloading all Git tags, if any.
# "--no-recurse-submodules" means to skip downloading submodules, if any.
# "--depth 1" means to do a "shallow" clone and only get the last commit.
# "--sparse" means to only get the files in the top-level directory. (More files can be added later.)
# (Azure DevOps does not support "--filter".)
git clone --config http.extraHeader="Authorization: Basic $BASE64_PAT" --no-checkout --no-tags --no-recurse-submodules --depth 1 --sparse "$REPOSITORY_URL"
REPOSITORY_NAME=$(basename $REPOSITORY_URL)
cd "$REPOSITORY_NAME"
git sparse-checkout add "$SPARSE_PATH"
git checkout
