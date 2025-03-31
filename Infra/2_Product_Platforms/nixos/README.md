# NixOS

This directory holds the configuration files for the company's [NixOS](https://nixos.org/) servers. NixOS is a Linux distribution that allows you to configure everything about the system from a centralized configuration file. In other words, it allows for infrastructure-as-code at the operating system level.

- The "modules" directory contains configs that are imported from other configs.
- The base configuration is located in "modules/base.nix". This should apply to every company server.
- The "hosts" directory contains configs for specific servers. Each file should have a name that corresponds to the host name and the virtual machine name.
- To create a new server based on NixOS, the "NixOS-24.05-Template" virtual machine template should be cloned. This can be done manually or by [Terraform](https://www.terraform.io/)/[Pulumi](https://www.pulumi.com/) code.

## TODO

- Make pipeline to auto-deploy to the servers.
- Active Directory integration does not work properly.
- Send all logs off-system using Azure Monitor Agent.
- Log all commands that are executed by lhadmin & root.
