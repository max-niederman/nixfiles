{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.desktop.wm.awesome;
in
{
  options.max.desktop.wm.awesome = {
    enable = mkEnableOption "Enable AwesomeWM";
  };

  config = mkIf cfg.enable {
    xsession.windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [];
    };
  };
}
