{
  config,
  options,
  pkgs,
  flakeRoot,
  ...
}:

{
  config = {
    nixpkgs.overlays = [
      (final: prev: {
        inherit (config.nixpkgs.lixPackageSets.stable)
          nixpkgs-review
          nix-eval-jobs
          nix-fast-build
          colmena
          ;
      })
    ];

    nix = {
      package = pkgs.lixPackageSets.stable.lix;
      extraOptions = ''
        experimental-features = nix-command flakes
        builders-use-substitutes = true
      '';
      settings = {
        trusted-users = [
          "root"
          "@wheel"
        ];

        substituters = [
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
          "https://cache.garnix.io"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        ];
      };
    };

    programs.nix-index.enable = true;
    programs.command-not-found.enable = false;

    programs.ssh = {
      extraConfig = ''
        Host eu.nixbuild.net
          PubkeyAcceptedKeyTypes ssh-ed25519
          ServerAliveInterval 60
          IPQoS throughput
          IdentityFile /root/.ssh/id_nixbuild
      '';

      knownHosts = {
        nixbuild = {
          hostNames = [ "eu.nixbuild.net" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
        };
      };
    };

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    nix.nixPath = options.nix.nixPath.default ++ [ "nixpkgs-overlays=/etc/nixos/overlays-compat" ];
    environment.etc."nixos/overlays-compat/overlays.nix".text = ''
      self: super:

      let
        inherit (super) lib;

        flake-compat = import (
          let lock = builtins.fromJSON (builtins.readFile ${flakeRoot}/flake.lock); in
          fetchTarball {
            url = lock.nodes.flake-compat.locked.url or "https://github.com/edolstra/flake-compat/archive/''${lock.nodes.flake-compat.locked.rev}.tar.gz";
            sha256 = lock.nodes.flake-compat.locked.narHash;
          }
        );

        outputs = (flake-compat { src = ${flakeRoot}; }).defaultNix;
        config = (outputs.nixosConfigurations.${config.networking.hostName}).config;
        overlays = config.nixpkgs.overlays;
      in
        lib.foldl' (lib.flip lib.extends) (_: super) overlays self
    '';
  };
}
