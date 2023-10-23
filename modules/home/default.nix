{ config, pkgs, lib, ... }:

{
  imports = [
    ./nix.nix
    ./shell.nix
    ./desktop.nix
    ./development.nix
    ./editor.nix
  ];
}
