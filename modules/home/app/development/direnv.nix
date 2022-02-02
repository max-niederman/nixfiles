{ config, pkgs, lib, ... }:

with lib;
{
  config = mkIf config.max.app.development.enable {
    programs.direnv = {
      enable = true;

      nix-direnv.enable = true;

      enableBashIntegration = true;
    };
  };
}
