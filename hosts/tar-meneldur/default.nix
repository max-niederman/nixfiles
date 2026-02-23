{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  system = {
    stateVersion = "25.05";
  };

  max = {
    headed = true;
    development = true;
    gaming = false;
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

  hardware.graphics.enable = true;

  environment.systemPackages = with pkgs; [ nvtopPackages.full ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.printing.enable = true;

  networking = {
    hostName = "tar-meneldur";
    hostId = "45d75591";
    networkmanager.enable = true;
  };

  time.timeZone = "America/Los_Angeles";

  home-manager.sharedModules = [
    {
      # use the state version of the system, from the NixOS config
      home.stateVersion = config.system.stateVersion;

      services.aurora-node = {
        enable = true;
        displayName = "Work Linux Machine - Tar-Meneldur";
      };

      programs.niri.settings.outputs = {
        # mechanize office display
        "Dell Inc. DELL U4025QW J8M9484" = {
          enable = true;
          mode = {
            width = 5120;
            height = 2160;
          };
          scale = 1;
          position = {
            x = 0;
            y = 0;
          };
          variable-refresh-rate = true;
          focus-at-startup = true;
        };
      };
    }
  ];
}
