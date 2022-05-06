{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.development;
in
{
  options.max.development = {
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

    containers.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable container virtualisation";
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = mkIf cfg.editor.enable {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    virtualisation.podman = mkIf cfg.containers.enable {
      enable = true;

      dockerCompat = true;
      dockerSocket.enable = true;
    };
  };
}
