{ config, pkgs, lib, ... }:

{
  config = {
    nix = {
      package = pkgs.nixUnstable;

      extraOptions = ''
        experimental-features = nix-command flakes
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
    };
  };
}
