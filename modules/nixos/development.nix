{ config, pkgs, lib, ... }:

{
  config = {
    virtualisation.podman = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    programs.wireshark = {
      enable = true;
    };

    environment.systemPackages = [
      config.boot.kernelPackages.perf
    ];
  };
}
