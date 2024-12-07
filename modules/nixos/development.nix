{
  config,
  pkgs,
  lib,
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

    virtualisation.podman = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    virtualisation.libvirtd = {
      enable = true;
    };

    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };

    programs.dublin-traceroute = {
      enable = true;
    };

    services.ollama = {
      enable = true;
    };

    environment.systemPackages = [
      config.services.ollama.package
      config.boot.kernelPackages.perf
    ];
  };
}
