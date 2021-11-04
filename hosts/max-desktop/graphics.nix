{ config, pkgs, lib, ... }:

{
  boot.initrd.kernelModules = [ "amdgpu" ];

  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    screenSection = ''
      Option "TearFree" "true"
    '';
  };

  hardware.opengl = {
    extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
    ];

    driSupport = true;
    driSupport32Bit = true;
  };
}
