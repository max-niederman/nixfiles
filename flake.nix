{
  description = "My Nix/Nixpkgs/NixOS code.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }:
    rec {
      overlays.default = import ./overlay;

      nixosModules.default = import ./modules/nixos;

      nixosConfigurations =
        let
          defaultModules = [
            {
              nixpkgs = {
                overlays = [ overlays.default ];
                config = {
                  allowUnfree = true;
                };
              };
            }
            hyprland.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.sharedModules = [
                hyprland.homeManagerModules.default
              ];
            }

            nixosModules.default
          ];
          system = { system, modules }: nixpkgs.lib.nixosSystem {
            modules = defaultModules ++ modules;
          };
        in
        {
          tar-elendil = system {
            system = "x86_64-linux";
            modules = [ ./hosts/tar-elendil ];
          };
        };
    };
}
