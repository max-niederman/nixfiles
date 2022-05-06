{ config, pkgs, lib, ... }:

with lib;
{
  config = mkIf (config.max.app.enable && config.max.desktop.enable) {
    programs = {
      firefox = {
        enable = true;
        package = pkgs.firefox-beta-bin;
      };

      chromium = {
        enable = true;
        package = pkgs.chromium.override { enableWideVine = true; };
      };
    };
  };
}
