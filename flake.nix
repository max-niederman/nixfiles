{
  description = "My Nix/Nixpkgs/NixOS code.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }:
    let
      inherit (nixpkgs) lib;

      overlay = import ./overlay;

      system = "x86_64-linux"; # TODO: add support for other archs
      pkgs = import nixpkgs {
        inherit system;
        allowUnfree = true;
        overlays = [ overlay ];
      };
    in
    rec {
      overlays.default = overlay;

      nixosModules = {
        default = import ./modules/nixos;
      };

      nixosConfigurations =
        let
          defaultModules = [
            home-manager.nixosModules.home-manager
            nixosModules.default
          ];
          system = modules: lib.nixosSystem {
            inherit system pkgs;
            modules = defaultModules ++ modules;
            specialArgs = {
              flakeInputs = inputs;
            };
          };
        in
        {
          tar-elendil = system [ ./hosts/tar-elendil ];
        };
    };
}
