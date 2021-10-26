{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.users;
in
{
  options.max.users = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to manage users.";
    };

    admins = mkOption {
      type = types.listOf types.str;
      default = [ "max" ];
      example = [ "max" ];
      description = "List of admin users to create.";
    };

    home-manager.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable home-manager.";
    };
  };

  config = mkIf cfg.enable {
    users.users = attrsets.genAttrs cfg.admins
      (name: {
        isNormalUser = true;
        createHome = true;
        extraGroups = [ "wheel" "docker" "networkmanager" ];
        shell = pkgs.fish;
      });

    programs.fish.enable = true;

    security.sudo.wheelNeedsPassword = false;

    home-manager = mkIf cfg.home-manager.enable {
      useGlobalPkgs = true;
      useUserPackages = true;
      sharedModules = [ ../home ];
    };
  };
}
