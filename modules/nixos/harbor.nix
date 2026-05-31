{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.services.harbor;

  netns = cfg.netns;

  ip = lib.getExe' pkgs.iproute2 "ip";
  wg = lib.getExe' pkgs.wireguard-tools "wg";
  jq = lib.getExe pkgs.jq;

  harbor-vpn-up = pkgs.writeShellScript "harbor-vpn-up" ''
    set -euo pipefail

    NETNS="${netns}"
    IFACE="wg-$NETNS"

    DEVICE_JSON="/etc/mullvad-vpn/device.json"
    SETTINGS_JSON="/etc/mullvad-vpn/settings.json"
    RELAYS_JSON="/var/cache/mullvad-vpn/relays.json"

    # Extract WireGuard private key and tunnel address from mullvad device config
    PRIVATE_KEY=$(${jq} -r '.logged_in.device.wg_data.private_key' "$DEVICE_JSON")
    TUNNEL_IPV4=$(${jq} -r '.logged_in.device.wg_data.addresses.ipv4_address' "$DEVICE_JSON")
    TUNNEL_IPV6=$(${jq} -r '.logged_in.device.wg_data.addresses.ipv6_address' "$DEVICE_JSON")

    RELAY=$(${jq} -r ".wireguard.relays | map(select(.location == \"us-sjc\")) | first" "$RELAYS_JSON")
    if [ "$RELAY" = "null" ] || [ -z "$RELAY" ]; then
      echo "No matching WireGuard relay found" >&2
      exit 1
    fi

    ENDPOINT_IP=$(echo "$RELAY" | ${jq} -r '.ipv4_addr_in')
    PEER_PUBKEY=$(echo "$RELAY" | ${jq} -r '.public_key')
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
    NETNS="${netns}"
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

    exec ${ip} netns exec ${netns} sudo -u "$CALLING_USER" -- "$@"
  '';
in
{
  options.services.harbor = {
    enable = lib.mkEnableOption "harbor network namespace";

    netns = lib.mkOption {
      type = lib.types.str;
      default = "harbor";
      description = "Name of the network namespace created for harbor.";
    };

    enableMullvad = lib.mkEnableOption "Mullvad WireGuard VPN inside the harbor namespace";

    lanPrefix = lib.mkOption {
      type = lib.types.str;
      default = "fc42:1651:0:0";
      example = "fd00:dead:beef:0";
      description = ''
        IPv6 /64 prefix used to connect the host to the harbor namespace
        over a veth pair. When set, the `harbor-lan` service is enabled:
        the host gets `''${lanPrefix}::1/64` and the namespace gets
        `''${lanPrefix}::2/64`. Leave `null` to disable LAN access.
      '';
    };
  };

  config = lib.mkMerge [
    {
      # The netns@ template is always available so namespaces can be
      # brought up independently of the harbor service itself.
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
    }

    (lib.mkIf (cfg.enable && cfg.enableMullvad) {
      systemd.services.harbor-vpn = {
        description = "Mullvad WireGuard VPN in harbor namespace";

        bindsTo = [ "netns@${netns}.service" ];
        after = [
          "netns@${netns}.service"
          "mullvad-daemon.service"
          "network-online.target"
        ];
        wants = [
          "network-online.target"
          "netns@${netns}.service"
        ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;

          ExecStart = harbor-vpn-up;
          ExecStop = harbor-vpn-down;
        };
      };

      environment.systemPackages = [ mullvad-run ];
    })

    (lib.mkIf (cfg.enable && cfg.lanPrefix != null) {
      systemd.services.harbor-lan = {
        description = "Harbor LAN Access";

        after = [ "netns@${netns}.service" ];
        requires = [ "netns@${netns}.service" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = [
            "${ip} link add vethharbor type veth peer name vethlan netns ${netns}"
            "${ip} addr add ${cfg.lanPrefix}::1/64 dev vethharbor"
            "${ip} link set dev vethharbor up"
            "${ip} -n ${netns} addr add ${cfg.lanPrefix}::2/64 dev vethlan"
            "${ip} -n ${netns} link set dev vethlan up"
          ];
          ExecStop = "${ip} link del vethharbor";
        };
      };
    })
  ];
}
