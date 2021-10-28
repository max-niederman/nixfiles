{ config, pkgs, lib, ... }:

{
  imports = [
    ./nix.nix
    ./users.nix
    ./development.nix
    ./desktop.nix
  ];
}
