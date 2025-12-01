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
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };

    # TODO: make this actually work
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
  };
}
