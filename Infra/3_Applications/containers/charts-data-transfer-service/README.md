# charts-data-transfer-service

- This is a microservice written in [TypeScript](https://www.typescriptlang.org/) that transfers form files from the "BEDPFEPM002" virtual machine to the "lhdatalakestoragestg" Azure storage account via SFTP.

## Algorithm

The program implements the following algorithm:

- Mount the "\\BEDPFEPM002\NtierFiles" SMB file share to the "/ntierfiles" directory.
- Starting from that directory, visit each company subdirectory. (e.g. "/ntierfiles/24x7 Emergency Care")
- If a directory named "277A", "277P", or "277U" exists, enter it.
- Copy all the subsequent files/directories to SFTP path "/claims/inbound-smb/[name-of-subdirectory]/[file-name]"
- As an exception, don't copy any directories that have a `YYYYMMDD` format that is before a certain threshold.

## Run

This application is intended to be run inside of a container using [Podman](https://podman.io/). You must provide all of the environment variables as specified in the "env.ts" file.
