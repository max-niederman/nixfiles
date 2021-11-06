{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.desktop.wallpaper;
in
{
  options.max.desktop.wallpaper = {
    enable = mkEnableOption "Enable wallpaper override.";
    name = mkOption {
      type = types.str;
      default = "nixos-light";
      description = "Name of wallpaper.";
    };
    path = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to wallpaper. Overrides `name` option.";
    };
  };

  config = mkIf cfg.enable {
    xsession.initExtra =
      let
        wallpaper = if cfg.path != null then cfg.path else {
          nixos-light = ./nixos-light.png;
          nixos-light-text = ./nixos-light-text.png;
        }.${cfg.name};
      in
      ''
        ${pkgs.feh}/bin/feh --bg-scale ${wallpaper}
      '';
  };
}
