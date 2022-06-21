{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.nix;
in
{
  options.max.nix = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Nix configuration.";
    };
  };

  config = {
    nix = mkIf cfg.enable {
      package = pkgs.nixUnstable;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';

      settings = {
        substituters = [
          "https://cachix.cachix.org"
          "https://nix-community.cachix.org"
          "https://niederman.cachix.org"
          "https://cache.iog.io" # alternative haskell infrastructure
        ];
        trusted-public-keys = [
          "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "niederman.cachix.org-1:RHf23lVKJ95Lb/5NEoMTGUUns8zg9/jIHNJXXekUoZc="
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      cachix
    ];
  };
}
