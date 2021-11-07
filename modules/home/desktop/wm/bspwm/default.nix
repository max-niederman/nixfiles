{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.desktop.wm.bspwm;
in
{
  options.max.desktop.wm.bspwm = {
    enable = mkEnableOption "Enable BSPWM";

    sxhkd.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the Simple X Hotkey Daemon.";
    };

    monitors = mkOption {
      type = with types; attrsOf (listOf str);
      default = { };
      example = {
        "eDP-1" = [ "I" "II" "III" "IV" "V" "VI" "VII" "IIX" "IX" "X" ];
      };
      description = "BSPWM monitor description.";
    };
  };

  config = mkIf cfg.enable {
    xsession.windowManager.bspwm = {
      enable = true;

      monitors = cfg.monitors;

      settings = {
        border_width = 1;
        window_gap = 15;
      };

      rules = {
        "Zathura" = {
          state = "tiled";
        };
        "Picture-in-Picture" = {
          state = "floating";
        };
      };
    };

    services.flameshot.enable = true;

    services.sxhkd = mkIf cfg.sxhkd.enable {
      enable = true;
      keybindings = import ./keybindings.nix {
        terminal = "${config.programs.alacritty.package}/bin/alacritty";
        browser = "${config.programs.firefox.package}/bin/.firefox-wrapped";
        launcher = "${config.programs.rofi.package}/bin/rofi";
        flameshot = "${pkgs.flameshot}/bin/flameshot";
      };
    };
  };
}
