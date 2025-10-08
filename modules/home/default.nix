{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./shell.nix
    ./development.nix
    ./editor.nix
    ./desktop
  ];

  config = {
    catppuccin = {
      enable = true;
      accent = "flamingo";
      flavor = "macchiato";
    };
  };
}
