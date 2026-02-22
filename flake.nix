{
  description = "My Nix/Nixpkgs/NixOS code.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zed = {
      url = "github:zed-industries/zed";
    };
    claude-code.url = "github:sadjow/claude-code-nix";
    moltbot = {
      url = "github:moltbot/nix-moltbot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };

  outputs =
    {
      nixpkgs,
      disko,
      sops-nix,
      stylix,
      home-manager,
      niri,
      noctalia,
      zen,
      zed,
      claude-code,
      moltbot,
      spicetify-nix,
      nix-vscode-extensions,
      ...
    }@inputs:
    rec {
      overlays.default = import ./overlay;

      nixosModules.default = import ./modules/nixos;

      nixosConfigurations =
        let
          defaultModules = [
            {
              _module.args = {
                flakeRoot = ./.;
                flakeInputs = inputs;
              };

              home-manager.extraSpecialArgs = {
                flakeRoot = ./.;
                flakeInputs = inputs;
              };
            }
            {
              nixpkgs = {
                overlays = [
                  zed.overlays.default
                  nix-vscode-extensions.overlays.default
                  claude-code.overlays.default
                  moltbot.overlays.default
                  overlays.default
                ];
                config = {
                  allowUnfree = true;
                };
              };
            }
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            noctalia.nixosModules.default
            stylix.nixosModules.stylix
            sops-nix.nixosModules.sops

            {
              home-manager.sharedModules = [
                niri.homeModules.niri
                noctalia.homeModules.default
                zen.homeModules.beta
                moltbot.homeManagerModules.moltbot
                spicetify-nix.homeManagerModules.spicetify
              ];
            }

            nixosModules.default
          ];
          system = { system, modules }: nixpkgs.lib.nixosSystem { modules = defaultModules ++ modules; };
        in
        {
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
            pkgs.disko
          ];
        }
      );

      formatter = nixpkgs.lib.attrsets.genAttrs [ "x86_64-linux" ] (
        system: nixpkgs.legacyPackages.${system}.nixfmt-tree
      );
    };
}
