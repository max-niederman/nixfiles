{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.dev;
in
{
  options.max.dev = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable system-wide development software and configurations.";
    };

    editor.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable text editors.";
    };

    docker.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Docker virtualisation";
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = mkIf cfg.editor.enable {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    virtualisation.docker.enable = cfg.docker.enable;
  };
}
