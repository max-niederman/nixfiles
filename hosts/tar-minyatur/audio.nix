{ config, pkgs, lib, ... }:

{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;

    pulse.enable = true;
  };

  home-manager.sharedModules = [{
    services.easyeffects.enable = true;
  }];
}
