{ config, pkgs, lib, ... }:

{
  imports = [
    ./font.nix
    ./shell.nix
    ./desktop
    ./app
  ];

  config = {
    nixpkgs.config.allowUnfree = true;

    # Without this, home-manager thinks we're using 18.03 for some reason.
    home.stateVersion = lib.trivial.release;
  };
}
