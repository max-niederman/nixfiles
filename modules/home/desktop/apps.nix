{
  pkgs,
  lib,
  flakeInputs,
  ...
}:

let
  spicePkgs = flakeInputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  config = {
    services.easyeffects = {
      enable = true;
    };

    programs.mpv = {
      enable = true;
    };

    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };
    stylix.targets.spicetify.enable = false;

    # for Vesktop
    services.arrpc = {
      enable = true;
    };

    home.packages = with pkgs; [
      qpwgraph

      anki

      audacity

      vesktop
      slack
      zoom-us

      jellyfin-mpv-shim

      osu-lazer-bin
      prismlauncher

      waystt
    ];
  };
}
