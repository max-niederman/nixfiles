{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.desktop;
in
{
  imports = [
    ./launcher.nix
    ./wallpaper
    ./wm
  ];

  options.max.desktop = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Desktop.";
    };

    dirs.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to override XDG user directories.";
    };

    laptop = mkOption {
      type = types.bool;
      default = false;
      description = "Enable laptop-specific features.";
    };
  };

  config = mkIf cfg.enable {
    xsession.enable = true;

    xdg.userDirs = mkIf cfg.dirs.enable {
      enable = true;
      desktop = "$HOME/desktop";
      documents = "$HOME/documents";
      download = "$HOME/downloads";
      music = "$HOME/music";
      pictures = "$HOME/pictures";
      videos = "$HOME/videos";
    };

    max.desktop = {
      launcher.enable = true;
      wallpaper.enable = true;
      wm = {
        awesome.enable = false;
        bspwm.enable = true;
      };
    };
  };
}
