{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.path;
in
{
  imports = [

  ];

  options.max.path = { };

  config = { };
}
