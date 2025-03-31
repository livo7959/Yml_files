# - This is the entry point for a server's NixOS configuration.
# - It is intended to live at: /etc/nixos/flake.nix
# - The "hostname" parameter is intended to match the intended hostname of the system.
# - In order for the repository clone to work, the SSH key for the "svc_nixos" user must exist at
#   "/root/.ssh/id_rsa".

{
  inputs = {
    infrastructure.url = "git+ssh://azuredevops.logixhealth.com:22/LogixHealth/Infrastructure/_git/infrastructure?ref=feature/jnesta/certs-website-2&dir=2_Product_Platforms/nixos";
  };

  outputs = { self, infrastructure }:
    infrastructure.nixos-config {
      hostname = "foo";
    };
}
