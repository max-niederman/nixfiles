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

    programs.niri.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    security.rtkit.enable = true;

    services.printing.enable = true;

    hardware.opentabletdriver.enable = true;

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

    programs.dconf.enable = true;

    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      fonts = {
        serif = {
          package = pkgs.ibm-plex;
          name = "IBM Plex Serif";
        };

        sansSerif = {
          package = pkgs.ibm-plex;
          name = "IBM Plex Sans";
        };

        monospace = {
          package = pkgs.nerd-fonts.fira-code;
          name = "FiraCode Nerd Font";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };
    };

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
