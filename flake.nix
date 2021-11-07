{
  description = "My NixOS configurations.";

  inputs = {
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    nixpkgs.url = "github:NixOS/nixpkgs";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, utils, nixpkgs, nur, home-manager, ... }: utils.lib.mkFlake {
    inherit self inputs;

    supportedSystems = [ "x86_64-linux" ];

    ### Channels ###

    channelsConfig = {
      allowUnfree = true;
    };

    sharedOverlays = [ nur.overlay ];

    ### Default ###

    hostDefaults.modules = [
      home-manager.nixosModules.home-manager
      ./modules/nixos
    ];

    ### Hosts ###

    hosts = {
      run = {
        builder = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem;
        modules = [ ./hosts/run.nix ];
      };

      wsl = {
        modules = [ ./hosts/wsl ];
      };

      tar-minyatur.modules = [ ./hosts/tar-minyatur ];
    };

    ### Development Environment ###

    outputsBuilder = channels:
      with channels.nixpkgs;
      with (import ./scripts.nix { pkgs = channels.nixpkgs; });
      {
        devShell = mkShell {
          buildInputs = [
            cachix
            nixpkgs-fmt
            (nixos-generators.override { nix = nixUnstable; })
            qemu_kvm

            nixfiles-run
          ];

          NIX_PATH = "nixpkgs=channel:nixos-unstable";
        };
      };
  };
}
