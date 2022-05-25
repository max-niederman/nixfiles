{ lib, pkgs, config, modulesPath, ... }:

with lib;
let
  defaultUser = "max";
  syschdemd = import ./syschdemd.nix { inherit lib pkgs config defaultUser; };
in
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
  ];

  # WSL is closer to a container than anything else
  boot.isContainer = true;

  environment.etc.hosts.enable = false;
  environment.etc."resolv.conf".enable = false;

  # No clue what this does, but it doesn't build without it
  environment.noXlibs = false;

  networking.dhcpcd.enable = false;

  users.mutableUsers = mkForce true;
  users.users.${defaultUser} = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
  };

  users.users.root = {
    shell = "${syschdemd}/bin/syschdemd";
    # Otherwise WSL fails to login as root with "initgroups failed 5"
    extraGroups = [ "root" ];
  };

  security.sudo.wheelNeedsPassword = false;

  # Disable systemd units that don't make sense on WSL
  systemd.services."serial-getty@ttyS0".enable = false;
  systemd.services."serial-getty@hvc0".enable = false;
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@".enable = false;

  systemd.services.firewall.enable = false;
  systemd.services.systemd-resolved.enable = false;
  systemd.services.systemd-udevd.enable = false;

  # Don't allow emergency mode, because we don't have a console.
  systemd.enableEmergencyMode = false;

  # Start user-mode daemon.
  systemd.targets.user-daemon = {
    wants = [ "user@${defaultUser}.service" ];
    wantedBy = [ "multi-user.target" ];
  };

  services.vscode-server.enable = true;

  max = {
    users.admins = [ defaultUser ];
    desktop.enable = false;
  };

  home-manager.users.${defaultUser} = {
    max = {
      font.enable = false;
      desktop.enable = false;
    };
  };
}
