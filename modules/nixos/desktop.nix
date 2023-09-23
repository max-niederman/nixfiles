{ config, pkgs, lib, ... }:

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

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    i18n.inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ mozc ];
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

    programs.light.enable = true;
    services.actkbd = {
      enable = true;
      bindings = [
        { keys = [ 224 ]; events = [ "key" ]; command = "/run/wrappers/bin/light -A 10"; }
        { keys = [ 225 ]; events = [ "key" ]; command = "/run/wrappers/bin/light -U 10"; }
      ];
    };

    environment.systemPackages = with pkgs; [
      xdg-utils # for stuff like xdg-open
    ];

    services.gnome.gnome-keyring.enable = true;

    fonts = {
      fonts = with pkgs; [
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
      enableDefaultFonts = false;

      fontconfig.defaultFonts = {
        serif = [ "IBM Plex Serif" "Noto Serif CJK" "Noto Color Emoji" ];
        sansSerif = [ "IBM Plex Sans" "Noto Sans CJK" "Noto Color Emoji" ];
        monospace = [ "IBM Plex Mono" "Noto Sans Mono CJK" "Noto Color Emoji" ];
      };

      fontDir.enable = true;
    };

    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    programs.steam = {
      enable = true;
    };
  };
}
