{ pkgs, ... }:

{
  config = {
    programs.zen-browser = {
      enable = true;
    };

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

      jellyfin-mpv-shim

      prismlauncher
    ];
  };
}
