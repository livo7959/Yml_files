{ nixpkgs, agenix }:
{ hostname }:

{
  nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      agenix.nixosModules.default # The agenix module
      {
        environment.systemPackages = [ agenix.packages.x86_64-linux.default ]; # The agenix CLI
      }
      ../hosts/${hostname}.nix
    ];
  };
}
