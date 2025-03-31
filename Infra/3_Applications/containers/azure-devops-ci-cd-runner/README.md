# `azure-devops-ci-cd-runner-container`

This is the source code for the LogixHealth Azure DevOps CI/CD runner. (Once the container is created, we instantiate it on the "BEDPCONHOST001" virtual machine.)

# Changes From Upstream

This repository was originally forked from [`Azure-Samples/container-apps-ci-cd-runner-tutorial`](https://github.com/Azure-Samples/container-apps-ci-cd-runner-tutorial).

The changes are as follows:

- Removed the GitHub parts of the code.
- Added the company's self-signed certificate.
- Edited the "start.sh" file to run forever (instead of exiting after finishing the job).
- Edited the "start.sh" file to have more validation.
