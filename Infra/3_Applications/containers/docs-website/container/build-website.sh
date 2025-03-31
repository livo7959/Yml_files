#!/bin/bash

set -euo pipefail # Exit on errors and undefined variables.

# Get the directory of this script:
# https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

GIT_REPO="/repositories/infrastructure"

if [ -d "$GIT_REPO" ]; then
  cd "$GIT_REPO"
  git pull
else
  mkdir -p "$GIT_REPO"
  git clone https://$AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN@azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/infrastructure "$GIT_REPO"
  cd "$GIT_REPO"
fi

LATEST_SHA1=$(git rev-parse HEAD)

cd "$DIR"
cp --recursive /repositories/infrastructure/docs "$DIR/docs"

# Add the latest commit SHA1 to the introduction page, which can be helpful for troubleshooting
# which version of the docs is currently deployed.
INTRO_PATH="$DIR/docs/introduction.md"
echo >> "$INTRO_PATH"
echo "(This specific version of the site was deployed from commit [\`$LATEST_SHA1\`](https://azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/infrastructure/commit/$LATEST_SHA1).)" >> "$INTRO_PATH"

# Build the website using the new Markdown files.
rm -rf "$DIR/build"
npm run build

# Copy the build output to where Nginx expects it.
cp "$DIR/build" /usr/share/nginx/html/
