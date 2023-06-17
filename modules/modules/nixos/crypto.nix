{ config, pkgs, lib, ... }:

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
  };
}
