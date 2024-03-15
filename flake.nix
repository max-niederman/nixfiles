{
  description = "My Nix/Nixpkgs/NixOS code.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    secrets.url = "git+ssh://git@github.com/max-niederman/nixfiles-secrets";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    frc-nix = {
      url = "github:FRC3636/frc-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, secrets, home-manager, frc-nix, hyprland, nix-alien, ... }:
    rec {
      overlays.default = import ./overlay;

      nixosModules.default = import ./modules/nixos;

      nixosConfigurations =
        let
          defaultModules = [
            {
              nixpkgs = {
                overlays = [
                  frc-nix.overlays.default
                  nix-alien.overlays.default
                  overlays.default
                ];
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
            specialArgs = { inherit secrets; };
          };
        in
        {
          tar-minyatur = system {
            system = "x86_64-linux";
            modules = [ ./hosts/tar-minyatur ];
          };
          tar-elendil = system {
            system = "x86_64-linux";
            modules = [ ./hosts/tar-elendil ];
          };
        };
    };
}
