{
  pkgs,
  ...
}:

{
  config = {
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
