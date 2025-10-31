{ pkgs, ... }:

{
  config = {
    # greeter
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = ''
            ${pkgs.tuigreet}/bin/tuigreet \
              --cmd /run/current-system/sw/bin/niri-session \
              --remember \
              --remember-session \
              --asterisks \
              --power-shutdown "systemctl poweroff" \
              --power-reboot "systemctl reboot" \
              --window-padding 4 \
              --container-padding 4
          '';
          user = "greeter";
        };
      };
    };

    # window manager
    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };

    # shell
    services.noctalia-shell.enable = true;

    # audio
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    security.rtkit.enable = true;

    # core XDG stuff
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

    # input devices
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
    hardware.opentabletdriver.enable = true;

    # security
    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;

    # styling
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      polarity = "dark";
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
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
    };

    # fonts
    fonts = {
      packages = with pkgs; [
        ibm-plex

        source-sans
        source-serif

        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji

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

    # random device drivers
    services.printing.enable = true;

    # programs that need to be enabled system-wide
    programs.steam = {
      enable = true;
    };
  };
}
