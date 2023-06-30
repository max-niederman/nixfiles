{ config, pkgs, lib, ... }:

{
  imports = [
    ./shell.nix
    ./desktop.nix
    ./development.nix
  ];
}
