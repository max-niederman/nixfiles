{ config, pkgs, lib, ... }:

{
  config = {
    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
      daemon.settings = {
        features.buildkit = true;
      };
    };
  };
}