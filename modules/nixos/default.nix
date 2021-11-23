{ config, pkgs, lib, ... }:

{
  imports = [
    ./nix.nix
    ./users.nix
    ./networking
    ./development.nix
    ./desktop.nix
  ];

  config = {
    nixpkgs.config.allowUnfree = true;

    system = {
      stateVersion = lib.trivial.release;
      autoUpgrade.flake = lib.mkForce "github:max-niederman/nixfiles";
    };
  };
}
