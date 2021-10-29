{ config, pkgs, lib, ... }:

with lib;
{
  config = mkIf config.max.app.enable {
    programs = {
      lsd = {
        enable = true;
        enableAliases = true;
      };

      htop.enable = true;
      bat.enable = true;
    };
  };
}
