{
  description = "Homelab NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
      ...
    }@inputs:
    let
      nodes = [
        "nix-k3s-0"
        "nix-k3s-1"
        "nix-k3s-2"
      ];
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map (name: {
          name = name;
          value = nixpkgs.lib.nixosSystem {
            specialArgs = {
              meta = {
                hostname = name;
              };
            };
            system = "x86_64-linux";
            modules = [
              ./hardware-configuration.nix
              ./configuration.nix
            ];
          };
        }) nodes
      );
    };
}
