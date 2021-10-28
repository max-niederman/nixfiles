{ config, pkgs, lib, ... }:

with lib;
{
  config = mkIf config.max.app.enable {
    programs = {
      lsd = {
        enable = true;
        enableAliases = true;
      };

      bat.enable = true;
    };
  };
}
