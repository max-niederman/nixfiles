{ config, pkgs, lib, ... }:

with lib;
{
  config = mkIf (config.max.app.enable && config.max.desktop.enable) {
    programs = {
      firefox = {
        enable = true;
        package = pkgs.firefox-devedition-bin;
      };

      chromium = {
        enable = true;
        package = pkgs.ungoogled-chromium;
      };
    };
  };
}
