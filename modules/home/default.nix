{ config, pkgs, lib, ... }:

{
  imports = [
    ./font.nix
    ./shell.nix
    ./desktop
    ./app
  ];

  config = {
    # Without this, home-manager thinks we're using 18.03. IDFK
    home.stateVersion = lib.trivial.release;
  };
}
