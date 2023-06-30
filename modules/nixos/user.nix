{ config, pkgs, lib, ... }:

let
  secrets = import ./secrets.nix;
in
{
  config = {
    users = {
      mutableUsers = false;
      users.max = {
        isNormalUser = true;
        createHome = true;
        extraGroups = [
          "wheel"
          "video"
          "networkmanager"
          "docker"
        ];
        shell = pkgs.nushell;

        inherit (secrets) hashedPassword;

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINmdKg6WzEiyKysklc3YAKLjHEDLZq4RAjRYlSVbwHs9 max@tar-minyatur"
        ];
      };
    };

    security.sudo.wheelNeedsPassword = false;

    services.openssh.enable = true;

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
