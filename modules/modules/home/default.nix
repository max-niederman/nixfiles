{ config, pkgs, lib, ... }:

{
  imports = [
    ./shell.nix
    ./desktop.nix
  ];
}