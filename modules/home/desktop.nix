{ config, pkgs, lib, ... }:

{
  config = {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      nvidiaPatches.enable = true;
      recommendedEnvironment.enable = true;
    };
  };
}
