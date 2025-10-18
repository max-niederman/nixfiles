{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  config = {
    system = {
      stateVersion = "25.05";
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

      initrd.systemd.enable = true;
      zfs = {
        requestEncryptionCredentials = true;
        forceImportRoot = false;
        allowHibernation = true;
      };
    };

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.graphics.enable = true;
    hardware.nvidia = {
      open = true;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    services.ollama.acceleration = "cuda";

    environment.systemPackages = with pkgs; [ nvtopPackages.nvidia ];

    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    networking = {
      hostName = "tar-elendil";
      hostId = "2662d6f8";
      networkmanager.enable = true;
    };

    time.timeZone = "America/Los_Angeles";

    home-manager.sharedModules = [
      {
        # use the state version of the system, from the NixOS config
        home.stateVersion = config.system.stateVersion;

        programs.niri.settings.outputs = {
          # laptop built-in display
          "eDP-1" = {
            enable = true;
            mode = {
              width = 1920;
              height = 1200;
            };
            position = {
              x = 0;
              y = 0;
            };
          };

          # main home display
          "Shenzhen KTC Technology Group M27P6 0000000000001" = {
            enable = true;
            mode = {
              width = 3840;
              height = 2160;
            };
            scale = 1;
            position = {
              x = 1920;
              y = 1200 - 2160;
            };
            variable-refresh-rate = true;
            focus-at-startup = true;
          };

          # mechanize office display
          "Dell Inc. DELL U4025QW 49FC734" = {
            enable = true;
            mode = {
              width = 5120;
              height = 2160;
            };
            scale = 1;
            position = {
              x = -5120;
              y = 1200 - 2160;
            };
            variable-refresh-rate = true;
            focus-at-startup = true;
          };
        };
      }
    ];
  };
}
