{ config, pkgs, lib, ... }:

{
  imports = [
    ./nix.nix
    ./shell.nix
    ./desktop
    ./development.nix
    ./editor.nix
  ];

  config = {
    catppuccin = {
      enable = true;
      accent = "flamingo";
      flavor = "macchiato";
    };
  };
}
