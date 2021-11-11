{ config, pkgs, lib, ... }:

with lib;
{
  config = mkIf config.max.app.enable {
    programs = {
      gpg.enable = true;
    };

    services = {
      keybase.enable = true;
      gpg-agent.enable = true;
    };
  };
}
