{ config, pkgs, lib, ... }:

with lib;
{
  config = mkIf (config.max.app.enable && config.max.desktop.enable) {
    programs.alacritty = {
      enable = true;

      settings = {
        env = { "TERM" = "xterm-256color"; };
        window.padding = { x = 12; y = 12; };
        font = {
          size = 9.0;
          normal.family = config.max.font.selections.code.name;
        };
      };
    };
  };
}
