{
  config,
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

    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };

    programs.dublin-traceroute = {
      enable = true;
    };

    environment.systemPackages = [
      pkgs.perf
    ];
  };
}
