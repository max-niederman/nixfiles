{
  description = "My Nix/Nixpkgs/NixOS code.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    frc-nix.url = "github:FRC3636/frc-nix";

    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      sops-nix,
      lix,
      catppuccin,
      nix-vscode-extensions,
      frc-nix,
      ...
    }:
    rec {
      overlays.default = import ./overlay;

      nixosModules.default = import ./modules/nixos;

      nixosConfigurations =
        let
          defaultModules = [
            {
              _module.args = {
                flakeRoot = ./.;
              };
            }
            {
              nixpkgs = {
                overlays = [
                  nix-vscode-extensions.overlays.default
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
            lix.nixosModules.default
            catppuccin.nixosModules.catppuccin

            {
              home-manager.sharedModules = [ catppuccin.homeManagerModules.catppuccin ];
            }

            nixosModules.default
          ];
          system = { system, modules }: nixpkgs.lib.nixosSystem { modules = defaultModules ++ modules; };
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

      devShell = nixpkgs.lib.attrsets.genAttrs [ "x86_64-linux" ] (
        system:
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
        }
      );

      formatter = nixpkgs.lib.attrsets.genAttrs [ "x86_64-linux" ] (
        system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style
      );
    };
}
