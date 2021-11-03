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

      interception-tools.enable = cfg.rebindCaps;
    };
  };
}
