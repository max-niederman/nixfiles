{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.desktop.wm.bspwm;
in
{
  options.max.desktop.wm.bspwm = {
    enable = mkEnableOption "Enable BSPWM";

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
        # float godot debug window
        "Godot_Engine" = {
          state = "floating";
        };
      };
    };

    services.sxhkd = {
      enable = true;
      keybindings = import ./keybindings.nix {
        terminal = "${config.programs.alacritty.package}/bin/alacritty";
        browser = "${config.programs.firefox.package}/bin/.firefox-wrapped";
        launcher = "${config.programs.rofi.package}/bin/rofi";
        flameshot = "${pkgs.flameshot}/bin/flameshot";
      };
    };
    services.trayer.enable = true;
    services.flameshot.enable = true;
  };
}
