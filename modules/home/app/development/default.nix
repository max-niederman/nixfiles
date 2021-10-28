{ config, pkgs, lib, ... }:

with lib;
{
  imports = [
    ./vcs.nix
    ./direnv.nix
    ./editor
  ];

  options.max.app.development = {
    enable = mkEnableOption "Enable development apps.";
  };
}
