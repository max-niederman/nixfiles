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
    catppuccin.mpv.enable = true;

    # for Vesktop
    services.arrpc = {
      enable = true;
    };

    home.packages = with pkgs; [
      gnome-system-monitor
      nautilus

      anki

      sioyek

      vesktop

      jellyfin-mpv-shim

      prismlauncher
    ];
  };
}
