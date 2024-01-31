{ config, pkgs, lib, ... }:

{
  imports = [
    ./nix.nix
    ./desktop.nix
    ./user.nix
    ./crypto.nix
    ./development.nix
    ./network.nix
    ./boot.nix
    ./compat.nix
  ];
}
