{ lib, ... }:

{
  imports = [
    ./audio.nix
    ./boot.nix
    ./compat.nix
    ./crypto.nix
    ./desktop.nix
    ./gaming.nix
    ./input.nix
    ./network.nix
    ./nix.nix
    ./secrets.nix
    ./style.nix
    ./user.nix
    ./virtualization.nix
  ];

  options = {
    max = {
      headed = lib.mkEnableOption "Enable software and config for headed hosts";
      development = lib.mkEnableOption "Enable software and config for software development";
      gaming = lib.mkEnableOption "Enable software and config for gaming";
    };
  };
}
