{ config, pkgs, lib, ... }:

{
  networking = {
    hostName = "tar-minyatur";

    networkmanager.enable = true;

    # the firewall apparently blocks outgoing ssh connections
    firewall.enable = false;
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish.enable = true;
  };
}
