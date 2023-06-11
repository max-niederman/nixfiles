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

    networking = {
      hostName = "tar-elendil";
      networkmanager.enable = true;
    };

    home-manager.sharedModules = [{
      # use the state version of the system, from the **NixOS** config
      home.stateVersion = config.system.stateVersion;
    }];
  };
}
