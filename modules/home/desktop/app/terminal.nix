{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.desktop.app.terminal;
  terminalFont = if config.max.font.enable then config.max.font.selections.code.name else "FiraCode Nerd Font";
in
{
  options.max.desktop.app.terminal = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable terminal app(s).";
    };
  };

  config = {
    programs.alacritty = {
      enable = true;

      settings = {
        env = { "TERM" = "xterm-256color"; };
        window.padding = { x = 12; y = 12; };
        font = {
          size = 9.0;
          normal.family = terminalFont;
        };
      };
    };
  };
}
