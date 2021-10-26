{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max;
in
{
  imports = [
    ./font.nix
    ./shell
    ./desktop
  ];

  options.max = {
  };

  config = { };
}
