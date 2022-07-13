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

    users = mkOption {
      type = types.listOf types.str;
      default = [ "max" ];
      example = [ "max" ];
      description = "List of users to create.";
    };

    admins = mkOption {
      type = types.listOf types.str;
      default = [ "max" ];
      example = [ "max" ];
      description = "List of admin users.";
    };

    home-manager.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable home-manager.";
    };
  };

  config = mkIf cfg.enable {
    users.mutableUsers = false;
    users.users = attrsets.recursiveUpdate
      (attrsets.genAttrs cfg.users (name: {
        isNormalUser = true;
        createHome = true;
        shell = pkgs.fish;
      }))
      (attrsets.genAttrs cfg.admins (name: {
        extraGroups = [ "wheel" "podman" "docker" "networkmanager" ];
      }));

    programs.fish.enable = true;

    security.sudo.wheelNeedsPassword = false;

    home-manager = mkIf cfg.home-manager.enable {
      useGlobalPkgs = true;
      useUserPackages = true;
      sharedModules = [ ../home ];

      # if the user attribute doesn't exist, home-manager won't activate
      users = attrsets.genAttrs cfg.users (_: { });
    };
  };
}
