{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.networking;
in
{
  options.max.networking = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Networking.";
    };

    zerotier = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable ZeroTier.";
      };

      networks = mkOption {
        type = types.listOf types.str;
        default = import ./zerotier-networks.nix;
        description = "ZeroTier networks to join.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.zerotierone = mkIf cfg.zerotier.enable {
      enable = true;
      joinNetworks = cfg.zerotier.networks;
    };
  };
}
