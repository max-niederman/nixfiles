{
  config,
  pkgs,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  system = {
    stateVersion = "25.05";
  };

  max = {
    headed = true;
    development = true;
    gaming = true;
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

  services.sanoid = {
    enable = true;
    datasets."tank/safe" = {
      recursive = true;

      autosnap = true;
      autoprune = true;

      hourly = 12;
      daily = 7;
      monthly = 2;
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

  # FIXME: agh nvtop is broken for some goddamn reason
  environment.systemPackages = with pkgs; [ nvtopPackages.full ];

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.fprintd.enable = true;

  services.printing.enable = true;

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

      services.aurora-node = {
        enable = true;
        displayName = "Daily Driver Linux Laptop - Tar-Elendil";
      };

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
        "Dell Inc. DELL U4025QW J8M9484" = {
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

        # family home display
        "PNP(AOC) Q27G1WG4 0x00020A77" = {
          enable = true;
          mode = {
            width = 2560;
            height = 1440;
          };
          scale = 1;
          position = {
            x = 0;
            y = -1440;
          };
          variable-refresh-rate = false;
          focus-at-startup = true;
        };
      };
    }
  ];
}
