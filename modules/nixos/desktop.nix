{ pkgs, ... }:

{
  config = {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = ''
            ${pkgs.greetd.tuigreet}/bin/tuigreet \
              --cmd Hyprland \
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

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    sound = {
      enable = true;
      mediaKeys.enable = true;
    };
    security.rtkit.enable = true;

    services.printing.enable = true;

    hardware.opentabletdriver.enable = true;

    xdg = {
      mime.enable = true;
      icons.enable = true;
    };

    environment.systemPackages = with pkgs; [
      xdg-utils # for stuff like xdg-open
    ];

    programs.dconf.enable = true;

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

        (nerdfonts.override {
          fonts = [ "FiraCode" "Iosevka" ];
        })
      ];

      # use user-specified fonts rather than defaults
      enableDefaultPackages = false;

      fontconfig.defaultFonts = {
        serif = [ "IBM Plex Serif" "Noto Serif CJK" "Noto Color Emoji" ];
        sansSerif = [ "IBM Plex Sans" "Noto Sans CJK" "Noto Color Emoji" ];
        monospace = [ "IBM Plex Mono" "Noto Sans Mono CJK" "Noto Color Emoji" ];
      };

      fontDir.enable = true;
    };

    programs.steam = {
      enable = true;
    };
  };
}
