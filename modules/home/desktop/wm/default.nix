{ config, pkgs, lib, ... }:

{
  imports = [
    ./xmonad.nix
    ./bspwm.nix
  ];
}
