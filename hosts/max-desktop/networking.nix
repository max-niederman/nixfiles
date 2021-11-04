{ config, pkgs, lib, ... }:

{
  networking = {
    hostName = "max-desktop";

    networkmanager.enable = true;
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish.enable = true;
  };
}
