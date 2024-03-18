{ pkgs, ... }:

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
        pinentryPackage = pkgs.pinentry-gnome3;
      };
    };
  };
}
