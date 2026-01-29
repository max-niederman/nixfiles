{
  pkgs,
  ...
}:

{
  config = {
    # for Git signing
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
  };
}
