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

  config.nix = mkIf cfg.enable {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      substituters = [
        "https://cachix.cachix.org"
        "https://nix-community.cachix.org"
        "https://hydra.iohk.io"
      ];
      trusted-public-keys = [
        "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      ];
    };
  };
}
