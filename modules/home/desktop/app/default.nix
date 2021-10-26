{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.desktop.app;
in
{
  imports = [
    ./terminal.nix
  ];

  options.max.desktop.wm = { };
}
