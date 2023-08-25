{ config, pkgs, lib, ... }:

{
  config = {
    services.tailscale = {
      enable = true;
    };

    # see NixOS/nixpkgs#180175
    systemd.services.systemd-udevd.restartIfChanged = false;
  };
}
