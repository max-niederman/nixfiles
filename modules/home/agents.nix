{
  config,
  nixosConfig,
  pkgs,
  lib,
  ...
}:

{
  options.services.aurora-node = {
    enable = lib.mkEnableOption "Aurora node";
    displayName = lib.mkOption {
      type = lib.types.str;
      default = nixosConfig.networking.hostName;
      description = "The display name for the Aurora node service.";
    };
  };

  config = {
    systemd.user.services.aurora-node = {
      Unit = {
        Description = "Aurora node service";
      };
      Service = {
        ExecStart = "${pkgs.moltbot-gateway}/bin/moltbot node run --host aurora.banded-scala.ts.net --port 443 --tls --display-name '${config.services.aurora-node.displayName}'";
        Restart = "always";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    home.packages = with pkgs; [
      # moltbot cli
      moltbot-gateway

      # coding tuis
      (claude-code-bun.override {
        bunBinName = "claude";
      })
      codex
    ];
  };
}
