{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.desktop.wm;
in
{
  imports = [
    ./bspwm.nix
  ];

  options.max.desktop.wm = {

   };
}
