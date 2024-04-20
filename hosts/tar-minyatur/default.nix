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

    networking = {
      hostName = "tar-minyatur";
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
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;
      nvidiaSettings = true;
    };

    environment.variables = {
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    services.ollama.acceleration = "cuda";

    environment.systemPackages = with pkgs; [
      nvtopPackages.nvidia
    ];

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
