{
  config,
  pkgs,
  ...
}:

{
  config = {
    programs.nix-ld = {
      enable = true;
      libraries = [
        (pkgs.runCommand "steamrun-lib" { } "mkdir $out; ln -s ${pkgs.steam-run.fhsenv}/usr/lib64 $out/lib")
      ];
    };

    # for Git signing
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };

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
      };
    };

    virtualisation.containerd = {
      enable = true;
    };

    # buildkitd isn't in nixos yet unfortunately, so we need to manually configure it
    systemd.services.buildkit = {
      description = "Buildkit";

      requires = [ "buildkit.socket" ];
      after = [ "buildkit.socket" ];

      wants = [ "multi-user.target" ];

      serviceConfig = {
        Type = "notify";
        ExecStart = "${pkgs.buildkit}/bin/buildkitd --addr fd:// --oci-worker false --containerd-worker true";
      };
    };
    systemd.sockets.buildkit = {
      description = "BuildKit";

      wantedBy = [ "sockets.target" ];

      socketConfig = {
        ListenStream = "%t/buildkit/buildkitd.sock";
        SocketMode = "0660";
        SocketUser = "root";
        SocketGroup = "docker";
      };
    };

    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };

    programs.dublin-traceroute = {
      enable = true;
    };

    environment.systemPackages = [
      pkgs.perf
      pkgs.
      pkgs.buildkit
    ];
  };
}
