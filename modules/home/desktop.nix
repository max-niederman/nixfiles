{ config, pkgs, lib, flakeInputs, ... }:

let
  inherit (flakeInputs) hyprland;
in
{
  imports = [
    hyprland.homeManagerModules.default
  ];

  config = {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland = true;
      nvidiaPatches = true;
      recommendedEnvironment = true;
    };
  };
}
