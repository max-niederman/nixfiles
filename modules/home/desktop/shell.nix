{
  pkgs,
  lib,
  config,
  nixosConfig,
  ...
}:

{
  config = lib.mkIf nixosConfig.max.headed {
    programs.noctalia = {
      enable = true;
      systemd.enable = true;

      settings = {
        shell = {
          font_family = "Iosevka Nerd Font";
          launch_apps_as_systemd_services = true;
          clipboard_enabled = true;
        };

        backdrop.enabled = false;

        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
          templates = {
            enable_builtin_templates = false;
            enable_community_templates = false;
          };
        };

        wallpaper = {
          directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
          default.path = "${config.home.homeDirectory}/Pictures/Wallpapers/blue-mountain.jpg";
        };

        location.address = "San Francisco, CA";

        bar.main = {
          position = "left";
          margin_ends = 15;
          margin_edge = 20;

          thickness = 45;

          capsule = false;

          start = [
            "temp"
            "cpu"
            "ram"
            "network_rx"
            "network_tx"
            "active_window"
            "media"
          ];
          center = [ "workspaces" ];
          end = [
            "tray"
            "notifications"
            "battery"
            "volume"
            "brightness"
            "nightlight"
            "clock"
            "control-center"
          ];
        };

        widget = {
          temp.show_label = false;
          cpu.show_label = false;
          ram = {
            stat = "ram_pct";
            show_label = false;
          };
          network_rx.show_label = false;
          network_tx.show_label = false;
        };

        dock = {
          enabled = false;
          auto_hide = false;
          active_monitor_only = true;
        };
      };
    };

    home.sessionVariables.TERMINAL = lib.getExe config.programs.alacritty.package;

    stylix.targets.noctalia.enable = false;
  };
}
