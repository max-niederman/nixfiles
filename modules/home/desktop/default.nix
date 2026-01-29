{
  config,
  pkgs,
  lib,
  nixosConfig,
  ...
}:
{
  imports = [
    ./wm.nix
    ./shell.nix
    ./apps.nix
    ./browser.nix
  ];

  config = lib.mkIf nixosConfig.max.headed {
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
    };

    gtk = {
      enable = true;
    };

    home.file."Pictures/Wallpapers" = {
      source = ./wallpapers;
    };

    systemd.user.services.micromanage-notify = {
      Unit = {
        Description = "Micromanage notification";
      };
      Service = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "micromanage-notify" ''
          # Check if the monitor is attached using niri msg
          if ${pkgs.niri}/bin/niri msg outputs | grep -q "Dell Inc. DELL U4025QW J8M9484"; then
            ${pkgs.libnotify}/bin/notify-send "Micromanage" "Time to check in!"
          fi
        '';
      };
    };

    systemd.user.timers.micromanage-notify = {
      Unit = {
        Description = "Micromanage notification timer";
      };
      Timer = {
        OnCalendar = "hourly";
        Persistent = true;
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };

    home.packages = with pkgs; [
      # clipboard utilities
      wl-clipboard

      # color picker
      hyprpicker

      # audio
      pavucontrol
    ];
  };
}
