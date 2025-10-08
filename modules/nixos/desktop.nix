{ pkgs, ... }:

{
  config = {

    services.interception-tools = {
      enable = true;
      plugins = with pkgs.interception-tools-plugins; [ caps2esc ];

      # until nixpkgs#126681 is fixed, we need to manually specify the binary paths
      udevmonConfig =
        let
          tools = pkgs.interception-tools;
          plugins = pkgs.interception-tools-plugins;
        in
        ''
          - JOB: "${tools}/bin/intercept -g $DEVNODE | ${plugins.caps2esc}/bin/caps2esc | ${tools}/bin/uinput -d $DEVNODE"
            DEVICE:
              EVENTS:
                EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
        '';
    };

    programs.hyprland.enable = true;
    programs.niri.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    security.rtkit.enable = true;

    services.printing.enable = true;

    hardware.opentabletdriver.enable = true;

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
    };

    xdg = {
      mime.enable = true;
      icons.enable = true;
      portal = {
        enable = true;
        extraPortals = [
          # Enable three different portals for improved compatibility
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-gnome
          pkgs.xdg-desktop-portal-wlr
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      xdg-utils # for stuff like xdg-open
    ];

    # FIXME: is this needed?
    # programs.dconf.enable = true;

    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;

    fonts = {
      packages = with pkgs; [
        ibm-plex

        source-sans
        source-serif

        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-emoji

        eb-garamond
        garamond-premier-pro

        nerd-fonts.fira-code
        nerd-fonts.iosevka
      ];

      # use user-specified fonts rather than defaults
      enableDefaultPackages = false;

      fontconfig.defaultFonts = {
        serif = [
          "IBM Plex Serif"
          "Noto Serif CJK"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "IBM Plex Sans"
          "Noto Sans CJK"
          "Noto Color Emoji"
        ];
        monospace = [
          "IBM Plex Mono"
          "Noto Sans Mono CJK"
          "Noto Color Emoji"
        ];
      };

      fontDir.enable = true;
    };

    programs.steam = {
      enable = true;
    };
  };
}
