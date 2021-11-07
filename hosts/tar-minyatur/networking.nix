{ config, pkgs, lib, ... }:

{
  networking = {
    hostName = "tar-minyatur";

    networkmanager.enable = true;
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish.enable = true;
  };
}
