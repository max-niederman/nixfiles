{ pkgs, ... }:

{
  config = {
    environment.systemPackages = with pkgs; [
      nix-alien
    ];
  };
}
