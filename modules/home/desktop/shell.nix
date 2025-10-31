{
  pkgs,
  lib,
  config,
  ...
}:

{
  config = {
    programs.noctalia-shell = {
      enable = true;

      settings = {
        setupCompleted = true;

        general = {
          dimDesktop = false;
        };

        location = {
          name = "San Francisco, CA";
        };

        screenRecorder = {
          directory = "${config.home.homeDirectory}/Videos/Screencaps";
        };

        wallpaper = {
          directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
          defaultWallpaper = "${config.home.homeDirectory}/Pictures/Wallpapers/blue-mountain.jpg";
        };

        appLauncher = {
          terminalCommand = (lib.getExe config.programs.alacritty.package);
        };

        ui = {
          fontDefault = "Iosevka Nerd Font";
          fontFixed = "Iosevka Nerd Font";
        };

        colorSchemes = {
          predefinedScheme = "Catppuccin";
          generateTemplatesForPredefined = false;
        };

        bar = {
          density = "comfortable";
          position = "left";
          showCapsule = false;
          widgets = {
            left = [
              {
                id = "SystemMonitor";
                showCpuTemp = true;
                showCpuUsage = true;
                showDiskUsage = false;
                showMemoryAsPercent = true;
                showMemoryUsage = true;
                showNetworkStats = true;
              }
              {
                id = "ActiveWindow";
              }
              {
                id = "MediaMini";
              }
            ];
            center = [
              {
                id = "Workspace";
              }
            ];
            right = [
              {
                id = "ScreenRecorder";
              }
              {
                id = "Tray";
              }
              {
                id = "NotificationHistory";
              }
              {
                id = "Battery";
              }
              {
                id = "Volume";
              }
              {
                id = "Brightness";
              }
              {
                id = "NightLight";
              }
              {
                id = "Clock";
              }
              {
                id = "ControlCenter";
              }
            ];
          };
        };

        dock = {
          enabled = true;
          backgroundOpacity = 0.6;
          colorizeIcons = true;
          displayMode = "always_visible";
          floatingRatio = 0.5;
          size = 0.75;
          onlySameOutput = true;
        };
      };
    };
  };
}
