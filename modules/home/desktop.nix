{ config, pkgs, lib, ... }:

{
  config = {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      nvidiaPatches = true;
      recommendedEnvironment = true;
    };
  };
}
