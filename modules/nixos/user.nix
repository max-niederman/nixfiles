{ config, pkgs, lib, ... }:

{
  config = {
    users = {
      mutableUsers = false;
      users.max = {
        isNormalUser = true;
        createHome = true;
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        shell = pkgs.nushell;
      };
    };

    security.sudo.wheelNeedsPassword = false;

    # needed for shell completions
    programs.fish.enable = true;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      sharedModules = [ ../home ];

      # if the user attribute is not present, home-manager won't activate
      users = lib.attrsets.genAttrs [ "max" ] (_: { });
    };
  };
}
