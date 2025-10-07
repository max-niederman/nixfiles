{
  description = "My Nix/Nixpkgs/NixOS code.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    catppuccin.url = "github:catppuccin/nix";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      sops-nix,
      catppuccin,
      nix-vscode-extensions,
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
                  overlays.default
                ];
                config = {
                  allowUnfree = true;
                };
              };
            }
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            catppuccin.nixosModules.catppuccin

            {
              home-manager.sharedModules = [ catppuccin.homeModules.catppuccin ];
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

            nixos-install-tools
          ];
        }
      );

      formatter = nixpkgs.lib.attrsets.genAttrs [ "x86_64-linux" ] (
        system: nixpkgs.legacyPackages.${system}.nixfmt-tree
      );
    };
}
