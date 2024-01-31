{ config, pkgs, ... }:

{
  config = {
    programs.nix-ld = {
      enable = true;
      # TODO: add a default library list
      # libraries = with pkgs; [ ];
    };

    environment.systemPackages = with pkgs; [
      nix-alien
    ];
  };
}
