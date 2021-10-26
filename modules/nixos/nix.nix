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

    binaryCaches = mkOption {
      type = types.listOf types.str;
      default = [
        "https://cachix.cachix.org"
        "https://nix-community.cachix.org"
      ];
    };
    binaryCachePublicKeys = mkOption {
      type = types.listOf types.str;
      default = [
        "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  config.nix = mkIf cfg.enable {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    binaryCaches = cfg.binaryCaches;
    binaryCachePublicKeys = cfg.binaryCachePublicKeys;
  };
}
