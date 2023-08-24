{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    system = {
      stateVersion = "23.11";
    };

    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 20;
          editor = false;
        };
        timeout = 3;
      };
    };

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.opengl.enable = true;
    hardware.nvidia.prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    networking = {
      hostName = "tar-elendil";
      networkmanager.enable = true;
    };

    time.timeZone = "America/Los_Angeles";

    home-manager.sharedModules = [{
      # use the state version of the system, from the **NixOS** config
      home.stateVersion = config.system.stateVersion;

      wayland.windowManager.hyprland.extraConfig = ''
        monitor = eDP-1, 1920x1200@60, 0x0, 1
      '';
    }];
  };
}
