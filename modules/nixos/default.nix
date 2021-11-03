{ config, pkgs, lib, ... }:

{
  imports = [
    ./nix.nix
    ./users.nix
    ./development.nix
    ./desktop.nix
  ];

  config = {
    system.stateVersion = lib.trivial.release;
  };
}
