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
    gaming = true;
    backups = true;
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

    # the BIOS claims the SMBus I/O region via ACPI (\GSA1.SMBI), which blocks
    # i2c-piix4 from binding; lax lets it bind anyway so OpenRGB can reach the RAM
    kernelParams = [ "acpi_enforce_resources=lax" ];
  };

  hardware.graphics.enable = true;

  # RGB control for the Trident Z5 DIMMs (ENE controller on the SMBus)
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };

  environment.systemPackages = with pkgs; [ nvtopPackages.full ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.printing.enable = true;

  services.telemax.enable = true;

  networking = {
    hostName = "tar-meneldur";
    hostId = "45d75591";

    useNetworkd = true;
    # no catch-all DHCP networks; every link this host has is declared below
    useDHCP = false;
  };

  systemd.network = {
    # onboard 2.5GbE, the only link this machine is expected to have
    networks."10-lan" = {
      matchConfig.Name = "enp9s0";
      networkConfig = {
        DHCP = "yes";
        IPv6PrivacyExtensions = "kernel";
      };
      # networkd would otherwise identify itself by a machine-id-derived DUID,
      # which is not what a DHCP reservation is keyed on
      dhcpV4Config.ClientIdentifier = "mac";
      linkConfig.RequiredForOnline = "routable";
    };

    # dock/USB ethernet: configure it when it appears, but never hold up
    # network-online.target waiting for a NIC that isn't plugged in
    networks."20-usb-ethernet" = {
      matchConfig = {
        Type = "ether";
        Kind = "!*"; # physical interfaces have no kind
      };
      networkConfig = {
        DHCP = "yes";
        IPv6PrivacyExtensions = "kernel";
      };
      dhcpV4Config.RouteMetric = 200;
      linkConfig.RequiredForOnline = "no";
    };

    # this host does not do wifi: no supplicant runs, so the radio can never
    # associate, and networkd is told to leave the interface alone entirely
    networks."30-wireless-unmanaged" = {
      matchConfig.WLANInterfaceType = "station";
      linkConfig.Unmanaged = "yes";
    };

    # booting with the cable out shouldn't stall for the default two minutes
    wait-online.timeout = 30;
  };

  services.harbor.enable = true;

  time.timeZone = "America/Los_Angeles";

  home-manager.sharedModules = [
    {
      # use the state version of the system, from the NixOS config
      home.stateVersion = config.system.stateVersion;

      services.taiga-blocked = {
        enable = true;
        peers = [
          "http://tar-elendil:8432"
        ];
      };

      programs.niri.settings.outputs = {
        # home office display
        "Dell Inc. DELL U5226KW 9R7BNF4" = {
          enable = true;
          mode = {
            width = 6144;
            height = 2560;
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
