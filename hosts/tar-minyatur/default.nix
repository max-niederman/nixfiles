{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    system.stateVersion = "23.11";

    boot.loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
        useOSProber = true;
      };
      timeout = 3;
    };

    boot.supportedFilesystems = [ "zfs" ];
    boot.zfs.forceImportRoot = false;

    networking = {
      hostName = "tar-minyatur";
      hostId = "4d79803c";
      networkmanager.enable = true;
      firewall.enable = false;
    };

    time.timeZone = "America/Los_Angeles";

    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      # fixes flickering issues with 545+ drivers
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "535.154.05";
        sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
        sha256_aarch64 = "sha256-G0/GiObf/BZMkzzET8HQjdIcvCSqB1uhsinro2HLK9k=";
        openSha256 = "sha256-wvRdHguGLxS0mR06P5Qi++pDJBCF8pJ8hr4T8O6TJIo=";
        settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
        persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";

        patches = [
          (pkgs.fetchpatch {
            url = "https://github.com/gentoo/gentoo/raw/c64caf53/x11-drivers/nvidia-drivers/files/nvidia-drivers-470.223.02-gpl-pfn_valid.patch";
            hash = "sha256-eZiQQp2S/asE7MfGvfe6dA/kdCvek9SYa/FFGp24dVg=";
          })
        ];
      };

      modesetting.enable = true;
      nvidiaSettings = true;
    };

    environment.variables = {
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    services.ollama.acceleration = "cuda";

    home-manager.sharedModules = [{
      # use the state version of the system, from the **NixOS** config
      home.stateVersion = config.system.stateVersion;

      wayland.windowManager.hyprland.extraConfig = ''
        monitor = DP-2,     2560x1440@144, 0x0,    1
        monitor = DP-3,     2560x1440@120,  2560x0, 1
        monitor = HDMI-A-1, 1920x1080@75,  5120x0, 1

        workspace = 1, monitor:DP-2, default:true
        workspace = 2, monitor:DP-2
        workspace = 3, monitor:DP-2
        workspace = 4, monitor:DP-3, default:true
        workspace = 5, monitor:DP-3
        workspace = 6, monitor:DP-3
        workspace = 7, monitor:HDMI-A-1, default:true
        workspace = 8, monitor:HDMI-A-1
        workspace = 9, monitor:HDMI-A-1
      '';
    }];
  };
}
