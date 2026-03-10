{
  pkgs,
  ...
}:

{
  config = {
    security.pki.certificateFiles = [
      ./development-rootCA.pem
    ];

    services.resolved = {
      enable = true;
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
    };

    services.tailscale = {
      enable = true;
    };

    # Allow KDE Connect over the tailnet
    networking.firewall = {
      interfaces."tailscale0" = {
        allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
        allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
      };
    };

    services.mullvad-vpn = {
      enable = true;
    };

    # see NixOS/nixpkgs#180175
    systemd.services.systemd-udevd.restartIfChanged = false;

    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };

    programs.dublin-traceroute = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [ iptables ];
  };
}
