{ config, pkgs, lib, ... }:

with lib;
{
  config = mkIf (config.max.app.enable && config.max.desktop.enable) {
    home.packages = with pkgs; [
      # Reading
      calibre
      libgen-cli

      # Watching
      jellyfin-media-player
    ];

    programs = {
      # Reading
      zathura = {
        enable = true;

        options = {
          recolor = true;
          window-title-home-tilde = true;
          statusbar-basename = true;
          selection-clipboard = "clipboard";
        };
      };
    };
  };
}
