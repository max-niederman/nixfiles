{ config, pkgs, lib, ... }:

{
  networking = {
    networkmanager.enable = true;
  };

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      publish.enable = true;
    };
  };
}