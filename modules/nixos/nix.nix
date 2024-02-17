{ config, pkgs, lib, ... }:

{
  config = {
    nix = {
      package = pkgs.nixUnstable;

      extraOptions = ''
        experimental-features = nix-command flakes
        builders-use-substitutes = true
      '';

      settings = {
        trusted-users = [ "root" "@wheel" ];

        substituters = [
          "https://niederman.cachix.org"
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
        ];
        trusted-public-keys = [
          "niederman.cachix.org-1:RHf23lVKJ95Lb/5NEoMTGUUns8zg9/jIHNJXXekUoZc="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
      };

      distributedBuilds = true;
      buildMachines = [
        {
          hostName = "eu.nixbuild.net";
          systems = [ "aarch64-linux" ];
          protocol = "ssh";
          maxJobs = 100;
          supportedFeatures = [ "benchmark" "big-parallel" ];
        }
      ];
    };

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
  };
}
