{
  config,
  lib,
  ...
}:

let
  remoteHost = "fm3085b.rsync.net";
  remoteUser = "root";
  remotePrefix = "data1/machines/${config.networking.hostName}";
  sshKeyPath = config.sops.secrets."rsyncnet_ssh_key".path;

  replicated = [
    "root"
    "home"
  ];
in
{
  config = lib.mkIf config.max.backups {
    services.sanoid = {
      enable = true;
      datasets."tank/safe" = {
        recursive = true;

        autosnap = true;
        autoprune = true;

        hourly = 12;
        daily = 7;
        monthly = 0;
      };
    };

    services.zfs.autoScrub.enable = true;

    sops.secrets."rsyncnet_ssh_key" = {
      owner = config.services.syncoid.user;
      mode = "0400";
    };

    programs.ssh.knownHosts."rsyncnet" = {
      hostNames = [ remoteHost ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGh9Z6wcUYv2dWTqPC0FeweeGapV3e+Bc78GarqZyj/e";
    };

    services.syncoid = {
      enable = true;
      # offset from sanoid's on-the-hour snapshots
      interval = "*:15";

      commonArgs = [
        "--no-sync-snap"
        "--use-hold"
        "--compress=none"
      ];

      # the module default plus "release", which --use-hold needs to move its
      # hold forward after each successful sync
      localSourceAllow = [
        "bookmark"
        "hold"
        "release"
        "send"
        "snapshot"
        "destroy"
        "mount"
      ];

      # the module's SystemCallFilter excludes @timer, which SIGSYS-kills pv
      # (it calls setitimer for progress updates) and aborts the whole pipeline;
      # mkAfter because systemd applies these lines in order
      service.serviceConfig.SystemCallFilter = lib.mkAfter [ "setitimer" ];

      commands = lib.genAttrs (map (ds: "tank/safe/${ds}") replicated) (source: {
        target = "${remoteUser}@${remoteHost}:${remotePrefix}/${baseNameOf source}";
        # raw send: the remote only ever holds ciphertext
        sendOptions = "w";
        recvOptions = "u";
        sshKey = sshKeyPath;
      });
    };

    # syncoid never prunes the target, so thin out the remote snapshots:
    # hourlies after 2 weeks, dailies after 90 days, monthlies after a year.
    # The newest 10 snapshots per dataset are always kept so the incremental
    # chain survives even if this machine stays off for months.
    systemd.services.rsyncnet-prune = {
      description = "Prune old ZFS snapshots on rsync.net";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = config.services.syncoid.user;
        Group = config.services.syncoid.group;
      };
      script = ''
        set -euo pipefail
        now=$(date +%s)
        remote() {
          ${lib.getExe' config.programs.ssh.package "ssh"} \
            -i ${lib.escapeShellArg sshKeyPath} -o IdentitiesOnly=yes -o BatchMode=yes \
            ${remoteUser}@${remoteHost} "$@"
        }

        for ds in ${toString replicated}; do
          remote "zfs list -Hp -t snapshot -o name,creation -s creation -d 1 ${remotePrefix}/$ds" |
            head -n -10 |
            while read -r name creation; do
              age=$(( now - creation ))
              case "$name" in
                *@autosnap_*_hourly) max=$(( 14 * 86400 )) ;;
                *@autosnap_*_daily) max=$(( 90 * 86400 )) ;;
                *@autosnap_*_monthly) max=$(( 365 * 86400 )) ;;
                *) continue ;;
              esac
              if [ "$age" -gt "$max" ]; then
                echo "destroying $name ($(( age / 86400 )) days old)"
                remote "zfs destroy $name" || echo "failed to destroy $name (held?)"
              fi
            done
        done
      '';
    };
    systemd.timers.rsyncnet-prune = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "weekly";
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
    };
  };
}
