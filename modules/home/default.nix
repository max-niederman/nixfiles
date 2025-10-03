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
  ];

  config = {
    catppuccin = {
      enable = true;
      accent = "flamingo";
      flavor = "macchiato";
    };
  };
}
