{
  lib,
  config,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.max.video {
    users.groups.video = { };

    users.users.max.extraGroups = [ "video" ];

    services.sonarr = {
      enable = true;
      group = "video";
    };
    services.radarr = {
      enable = true;
      group = "video";
    };

    services.prowlarr = {
      enable = true;
    };

    services.sabnzbd = {
      enable = true;
      group = "video";
      settings = {
        misc.port = 9090;
      };
    };

    services.qbittorrent = {
      enable = true;
      group = "video";
      webuiPort = 9091;
    };
    systemd.services."qbittorrent" = {
      bindsTo = [ "netns@${config.services.harbor.netns}.service" ];
      after = [ "netns@${config.services.harbor.netns}.service" ];
      wants = [
        "harbor-vpn.service"
        "harbor-lan.service"
      ];
      serviceConfig = {
        NetworkNamespacePath = "/run/netns/harbor";
      };
    };
    # This is needed because for some godforsaken reason *arr services don't support connecting over IPv6
    systemd.services."qbittorrent-webui-proxy" = {
      description = "Reverse proxy for qBittorrent WebUI into the harbor namespace";
      after = [ "harbor-lan.service" ];
      wants = [ "harbor-lan.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart =
          let
            netnsAddr = "${config.services.harbor.lanPrefix}::2";
          in
          pkgs.writeShellScript "qbittorrent-webui-proxy" ''
            ${lib.getExe pkgs.socat} TCP4-LISTEN:9091,bind=127.0.0.1,fork,reuseaddr TCP6:[${netnsAddr}]:9091 &
            ${lib.getExe pkgs.socat} TCP6-LISTEN:9091,bind=[::1],fork,reuseaddr TCP6:[${netnsAddr}]:9091 &
            wait -n
          '';
        Restart = "on-failure";
        DynamicUser = true;
      };
    };

    environment.systemPackages = with pkgs; [
      recyclarr
    ];
  };
}
