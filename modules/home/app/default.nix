{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.app;
in
{
  imports = [
    ./utility.nix
    ./terminal.nix
    ./browser.nix
    ./media.nix
    ./development
  ];

  options.max.app = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable apps.";
    };
  };

  config = mkIf cfg.enable {
    max.app = {
      development.enable = true;
    };
  };
}
