# DO NOT EDIT THIS FILE DIRECTLY! ANY CHANGES TO THIS FILE WILL BE OVERWRITTEN.
# INSTEAD, CREATE A PULL REQUEST TO THE APPROPRIATE FILE IN THE FOLLOWING DIRECTORY:
# https://azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/infrastructure?path=/2_Product_Platforms/nixos/hosts

{ ... }:

{
  imports = [
    ../modules/base.nix
  ];

  # By default, NixOS uses DHCP, so we have to specify an IP address and gateway.
  networking = {
    hostName = "nixos-template";
    useDHCP = false;
    interfaces = {
      ens192 = {
        ipv4.addresses = [
          {
            address = "10.10.33.99";
            prefixLength = 24; # Equivalent to: 255.255.255.0
          }
        ];
      };
    };
    defaultGateway = "10.10.33.1";
  };
}
