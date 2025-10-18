{ pkgs, ... }:

{
  config = {

    programs.chromium = {
      enable = true;
    };

    services.easyeffects = {
      enable = true;
    };

    programs.mpv = {
      enable = true;
    };

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
