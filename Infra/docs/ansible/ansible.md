# Ansible

[Ansible](https://www.ansible.com/) is a [configuration management](https://en.wikipedia.org/wiki/Configuration_management) tool used to automate system administration. This repository contains Ansible [playbooks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html) that LogixHealth uses to manage its on-prem virtual machines.

These playbooks are not typically executed from the local command line. Instead, they are executed from an [Azure pipeline](https://azure.microsoft.com/en-us/products/devops/pipelines) located in the `ci_cd` directory.

## Gotchas

Issue with 'create_windows_service' role. Error message = "Unhandled exception while executing module: You cannot call a method on a null-valued expression." Work-around = run powershell script to create windows service

```ps
SC create "ServiceName" BinPath="PathToExe"
```

### IIS `runtime_version`

Some playbooks in this repository configure virtual machines with [IIS](https://www.iis.net/), a Microsoft web server. Part of this configuration involves setting the `runtime_version`. For most hosts, this should be set to `v4.0`. However, some hosts are explicitly set to an empty string, which corresponds to "No Managed Code" in the IIS GUI.

(The underlying IIS config file should not contain the string of "No Managed Code", since that is only the GUI representation of an underlying empty string. Also note that removing the `runtime_version` line entirely in the playbook will cause an error, so it must be explicitly set to an empty string.)

## Formatting

The files in this repository are formatted with [Prettier](https://prettier.io/). If you use [VSCode](https://code.visualstudio.com/), files should automatically be formatted on save (using the [Prettier VSCode extension](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)). If incorrectly formatted files are committed, a CI/CD pipeline will complain.
