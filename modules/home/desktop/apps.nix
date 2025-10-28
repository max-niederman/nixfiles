{ pkgs, flakeInputs, ... }:

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
      anki

      vesktop
      slack

      jellyfin-mpv-shim

      prismlauncher
    ];
  };
}
