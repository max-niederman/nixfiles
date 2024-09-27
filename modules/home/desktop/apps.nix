{pkgs,...}:

{
  config = {
    programs.firefox = {
      enable = true;
    };

    programs.chromium = {
      enable = true;
    };

    services.easyeffects = {
      enable = true;
    };

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

      mpv
      jellyfin-mpv-shim

      prismlauncher
    ];
  };
}