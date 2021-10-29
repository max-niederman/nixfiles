{ lib, pkgs, config, modulesPath, ... }:

with lib;
let
  defaultUser = "max";
  syschdemd = import ./syschdemd.nix { inherit lib pkgs config defaultUser; };
in
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"

    (fetchTarball {
        url = "https://github.com/msteen/nixos-vscode-server/tarball/4ff559b20c2f9200ae59b4516bbc7c0cbc04b22d";
        sha256 = "14zqbjsm675ahhkdmpncsypxiyhc4c9kyhabpwf37q6qg73h8xz5";
    })
  ];

  # Enable VS Code server
  services.vscode-server.enable = true;

  # WSL is closer to a container than anything else
  boot.isContainer = true;

  environment.etc.hosts.enable = false;
  environment.etc."resolv.conf".enable = false;

  networking.dhcpcd.enable = false;

  users.users.${defaultUser} = {
    isNormalUser = true;
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