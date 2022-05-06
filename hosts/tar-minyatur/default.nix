{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./audio.nix
    ./desktop.nix
  ];

  users.users = lib.genAttrs
    [ "root" "max" ]
    (_: { hashedPassword = "$6$Ohc1YSDm2G$/SEepwBIsunwyKry74IcmQ.u7aRr.5XKv.AlymeYemadgn1irIVNe3yRhN/TOTYob56jgcAOD4km1yi/KGnNr."; });

  hardware = {
    cpu.amd.updateMicrocode = true;
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        version = 2;
        useOSProber = true;
        device = "nodev";
        efiSupport = true;
        enableCryptodisk = true;
        configurationLimit = 8;
      };
    };
    initrd.luks.devices = {
      root = {
        device = "/dev/nvme0n1p2";
        preLVM = true;
      };
    };
  };

  services.printing.enable = true;

  time.timeZone = "America/Los_Angeles";

  system.autoUpgrade = {
    enable = true;
    dates = "daily";
  };
}
