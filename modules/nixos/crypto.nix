{ config, pkgs, lib, ... }:

with lib;
{
  config = {
    services = {
      keybase.enable = true;
      kbfs.enable = true;
    };

    programs = {
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryFlavor = "curses";
      };
    };

    environment.systemPackages = with pkgs; [
      git-crypt
    ];
  };
}
