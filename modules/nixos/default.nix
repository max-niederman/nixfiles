{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max;
in
{
  imports = [
    ./nix.nix
    ./users.nix
    ./dev.nix
    ./desktop.nix
  ];

  options.max = { };

  config = { };
}
