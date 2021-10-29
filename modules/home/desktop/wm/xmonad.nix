{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.desktop.wm.xmonad;
in
{
  options.max.desktop.wm.xmonad = {
    enable = mkEnableOption "Enable xmonad window manager.";
  };

  config = mkIf cfg.enable {
    xsession.windowManager.xmonad = {
      enable = true;
    };
  };
}
