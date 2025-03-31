# This is the entry point for the company's centralized NixOS configuration. Individual servers
# import this flake in order to get the configuration specific to their hostname.

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    agenix.url = "github:ryantm/agenix"; # For secret management.
  };

  outputs = { self, nixpkgs, agenix }: {
    nixos-config = import ./modules/nixos-config.nix {
      inherit nixpkgs agenix;
    };
  };
}
