{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.desktop;
in
{
  options.max.desktop = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable X server and desktop settings.";
    };

    rebindCaps = mkOption {
      type = types.bool;
      default = true;
      description = "Rebind Caps-Lock to Escape and Control.";
    };
  };

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ mozc ];
    };

    services = {
      xserver = {
        enable = true;

        # defer session to home-manager configuration
        displayManager = {
          defaultSession = "defer";
          session = [
            {
              manage = "desktop";
              name = "defer";
              start = "exec $HOME/.xsession";
            }
          ];
        };

        layout = "us";
        xkbVariant = "altgr-intl";

        libinput.enable = true;
      };

      interception-tools = mkIf cfg.rebindCaps {
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


      # various applications, including VS Code, need the org.freedesktop.secrets service
      # this would be in home/app/crypto.nix, but it doesn't work there for whatever reason
      gnome.gnome-keyring.enable = true;
    };
  };
}
