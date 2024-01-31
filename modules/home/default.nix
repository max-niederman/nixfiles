{ config, pkgs, lib, ... }:

{
  imports = [
    ./nix.nix
    ./shell.nix
    ./desktop
    ./development.nix
    ./editor.nix
    ./compat.nix
  ];
}
