{ lib, ... }:

{
  imports = [
    ./audio.nix
    ./backups.nix
    ./boot.nix
    ./compat.nix
    ./desktop.nix
    ./gaming.nix
    ./harbor.nix
    ./input.nix
    ./network.nix
    ./nix.nix
    ./secrets.nix
    ./style.nix
    ./user.nix
    ./video.nix
    ./virtualization.nix
  ];

  options = {
    max = {
      headed = lib.mkEnableOption "Enable software and config for headed hosts";
      backups = lib.mkEnableOption "Enable ZFS snapshots and replication to rsync.net";
      development = lib.mkEnableOption "Enable software and config for software development";
      gaming = lib.mkEnableOption "Enable software and config for gaming";
      video = lib.mkEnableOption "Enable video downloading and streaming stack";
    };
  };
}
