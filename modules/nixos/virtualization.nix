{
  config,
  pkgs,
  lib,
  ...
}:

let
  # FIXME: gvisor broken on go 1.26, drop override after https://github.com/NixOS/nixpkgs/pull/503624 merges
  gvisor = pkgs.gvisor.override { buildGoModule = pkgs.buildGo125Module; };
in
{
  config = {
    virtualisation.docker = {
      enable = true;
      extraOptions = "--containerd /run/containerd/containerd.sock";
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
      daemon.settings = {
        max-concurrent-uploads = 12;
        features.containerd-snapshotter = true;
        runtimes = {
          runsc.path = "${gvisor}/bin/runsc";
        };
      };
    };

    virtualisation.containerd = {
      enable = true;
    };

    # buildkitd isn't in nixos yet unfortunately, so we need to manually configure it
    systemd.services.buildkit = lib.mkIf config.max.development {
      description = "Buildkit";

      requires = [ "buildkit.socket" ];
      after = [ "buildkit.socket" ];

      wants = [ "multi-user.target" ];

      serviceConfig = {
        Type = "notify";
        ExecStart = "${pkgs.buildkit}/bin/buildkitd --addr fd:// --oci-worker false --containerd-worker true --containerd-worker-namespace moby";
      };
    };
    systemd.sockets.buildkit = lib.mkIf config.max.development {
      description = "BuildKit";

      wantedBy = [ "sockets.target" ];

      socketConfig = {
        ListenStream = "%t/buildkit/buildkitd.sock";
        SocketMode = "0660";
        SocketUser = "root";
        SocketGroup = "docker";
      };
    };

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    security.wrappers.bwrap = {
      owner = "root";
      group = "root";
      setuid = true;
      source = "${pkgs.bubblewrap}/bin/bwrap";
    };

    environment.systemPackages =
      with pkgs;
      [
        skopeo
        crane
        oras

        perf
        gvisor
      ]
      ++ lib.optionals config.max.development [
        buildkit
      ];
  };
}
