{
  pkgs,
  lib,
  ...
}:

let
  ip = lib.getExe' pkgs.iproute2 "ip";
  wg = lib.getExe' pkgs.wireguard-tools "wg";
  jq = lib.getExe pkgs.jq;

  harbor-vpn-up = pkgs.writeShellScript "harbor-vpn-up" ''
    set -euo pipefail

    NETNS="harbor"
    IFACE="wg-$NETNS"

    DEVICE_JSON="/etc/mullvad-vpn/device.json"
    SETTINGS_JSON="/etc/mullvad-vpn/settings.json"
    RELAYS_JSON="/var/cache/mullvad-vpn/relays.json"

    # Extract WireGuard private key and tunnel address from mullvad device config
    PRIVATE_KEY=$(${jq} -r '.logged_in.device.wg_data.private_key' "$DEVICE_JSON")
    TUNNEL_IPV4=$(${jq} -r '.logged_in.device.wg_data.addresses.ipv4_address' "$DEVICE_JSON")
    TUNNEL_IPV6=$(${jq} -r '.logged_in.device.wg_data.addresses.ipv6_address' "$DEVICE_JSON")

    # Determine the relay location constraint from settings
    COUNTRY=$(${jq} -r '.relay_settings.normal.location.only.location.country // empty' "$SETTINGS_JSON")
    CITY=$(${jq} -r '.relay_settings.normal.location.only.location.city // empty' "$SETTINGS_JSON")

    # Pick a relay matching the constraint
    RELAY_FILTER='.countries[]'
    if [ -n "$COUNTRY" ]; then
      RELAY_FILTER="$RELAY_FILTER | select(.code == \"$COUNTRY\")"
    fi
    RELAY_FILTER="$RELAY_FILTER | .cities[]"
    if [ -n "$CITY" ]; then
      RELAY_FILTER="$RELAY_FILTER | select(.code == \"$CITY\")"
    fi
    RELAY_FILTER="$RELAY_FILTER | .relays[] | select(.active == true) | select(.endpoint_data.wireguard != null)"

    # Pick the first matching relay
    RELAY=$(${jq} -r "[$RELAY_FILTER] | first" "$RELAYS_JSON")
    if [ "$RELAY" = "null" ] || [ -z "$RELAY" ]; then
      echo "No matching WireGuard relay found" >&2
      exit 1
    fi

    ENDPOINT_IP=$(echo "$RELAY" | ${jq} -r '.ipv4_addr_in')
    PEER_PUBKEY=$(echo "$RELAY" | ${jq} -r '.endpoint_data.wireguard.public_key')
    ENDPOINT_PORT=51820

    echo "Using relay: $(echo "$RELAY" | ${jq} -r '.hostname') ($ENDPOINT_IP)"

    # Create WireGuard interface in default namespace
    ${ip} link add "$IFACE" type wireguard

    # Configure WireGuard
    ${wg} set "$IFACE" \
      private-key <(echo "$PRIVATE_KEY") \
      peer "$PEER_PUBKEY" \
        endpoint "$ENDPOINT_IP:$ENDPOINT_PORT" \
        allowed-ips 0.0.0.0/0,::/0

    # Move interface into the namespace
    ${ip} link set "$IFACE" netns "$NETNS"

    # Configure interface inside the namespace
    ${ip} -n "$NETNS" addr add "$TUNNEL_IPV4" dev "$IFACE"
    ${ip} -n "$NETNS" addr add "$TUNNEL_IPV6" dev "$IFACE"
    ${ip} -n "$NETNS" link set "$IFACE" up

    # Set up routing inside the namespace
    ${ip} -n "$NETNS" route add default dev "$IFACE"
    ${ip} -n "$NETNS" -6 route add default dev "$IFACE"

    # Set up DNS
    mkdir -p "/etc/netns/$NETNS"
    echo "nameserver 10.64.0.1" > "/etc/netns/$NETNS/resolv.conf"
  '';

  harbor-vpn-down = pkgs.writeShellScript "harbor-vpn-down" ''
    set -euo pipefail
    NETNS="harbor"
    IFACE="wg-$NETNS"

    # Delete the interface from inside the namespace (if namespace still exists)
    ${ip} -n "$NETNS" link del "$IFACE" 2>/dev/null || true

    # Clean up DNS config
    rm -f "/etc/netns/$NETNS/resolv.conf"
    rmdir "/etc/netns/$NETNS" 2>/dev/null || true
  '';

  mullvad-run = pkgs.writeShellScriptBin "mullvad-run" ''
    set -euo pipefail

    if [ $# -eq 0 ]; then
      echo "Usage: mullvad-run <command> [args...]" >&2
      exit 1
    fi

    CALLING_USER="''${SUDO_USER:-$USER}"

    # Ensure we're root
    if [ "$(id -u)" -ne 0 ]; then
      exec sudo "$0" "$@"
    fi

    # Ensure harbor-vpn is up
    systemctl start harbor-vpn.service

    exec ${ip} netns exec harbor sudo -u "$CALLING_USER" -- "$@"
  '';
in
{
  config = {
    systemd.services."netns@" = {
      description = "Named Network Namespace %i";

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;

        ExecStart = [
          "${ip} netns add %i"
          "${ip} -n %i link set lo up"
        ];
        ExecStop = "${ip} netns delete %i";

        # Clean up /etc/netns/%i on stop
        ExecStopPost = "-${pkgs.coreutils}/bin/rm -rf /etc/netns/%i";
      };
    };

    systemd.services.harbor-vpn = {
      description = "Mullvad WireGuard VPN in harbor namespace";

      bindsTo = [ "netns@harbor.service" ];
      after = [
        "netns@harbor.service"
        "mullvad-daemon.service"
        "network-online.target"
      ];
      wants = [ "netns@harbor.service" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;

        ExecStart = harbor-vpn-up;
        ExecStop = harbor-vpn-down;
      };
    };

    environment.systemPackages = [ mullvad-run ];
  };
}
