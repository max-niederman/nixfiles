{ config, pkgs, lib, ... }:

{
  imports = [
    ./nix.nix
    ./users.nix
    ./networking
    ./development.nix
    ./desktop.nix
    ./crypto.nix
  ];

  config = {
    nixpkgs.config = {
      allowUnfree = true;
    };

    system = {
      stateVersion = lib.trivial.release;
    };
  };
}
