{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.desktop.launcher;
in
{
  options.max.desktop.launcher = {
    enable = mkEnableOption "Enable application launcher.";
  };

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = with pkgs; (rofi.override {
        plugins = [ rofi-emoji ];
        theme = null; # TODO: Add theme.
      });
    };
  };
}