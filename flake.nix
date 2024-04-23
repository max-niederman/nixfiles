{
  description = "My Nix/Nixpkgs/NixOS code.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
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
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, sops-nix, frc-nix, hyprland, hypridle, hyprlock, ... }:
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
                  overlays.default
                ];
                config = {
                  allowUnfree = true;
                };
              };
            }
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            hyprland.nixosModules.default
            {
              home-manager.sharedModules = [
                hyprland.homeManagerModules.default
                hypridle.homeManagerModules.default
                hyprlock.homeManagerModules.default
              ];
            }

            nixosModules.default
          ];
          system = { system, modules }: nixpkgs.lib.nixosSystem {
            modules = defaultModules ++ modules;
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
    
      devShell = nixpkgs.lib.attrsets.genAttrs ["x86_64-linux"] (system: 
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.mkShell {
          name = "max-nixfiles";
          packages = with pkgs; [
            sops
            age
            ssh-to-age
          ];
        });
    };
}
