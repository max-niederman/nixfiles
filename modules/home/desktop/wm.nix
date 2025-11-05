{
  config,
  pkgs,
  lib,
  ...
}:

{
  config = {
    programs.niri = {
      enable = true;
      package = pkgs.niri;

      settings = {
        xwayland-satellite = {
          enable = true;
          path = lib.getExe pkgs.xwayland-satellite;
        };

        input = {
          keyboard = {
            xkb.layout = "us";
            xkb.variant = "altgr-intl";
          };

          touchpad = {
            click-method = "clickfinger";
            dwt = true;
          };
        };

        cursor = {
          size = 16;
        };

        prefer-no-csd = true;
        window-rules = [
          {
            clip-to-geometry = true;
            geometry-corner-radius = lib.attrsets.genAttrs [
              "top-left"
              "top-right"
              "bottom-left"
              "bottom-right"
            ] (_: 4.0);
          }
        ];

        binds =
          with config.lib.niri.actions;
          let
            noctalia-ipc = spawn "noctalia-shell" "ipc" "call";
          in
          {
            "Mod+H".action = focus-column-or-monitor-left;
            "Mod+J".action = focus-window-or-workspace-down;
            "Mod+K".action = focus-window-or-workspace-up;
            "Mod+L".action = focus-column-or-monitor-right;

            "Mod+Shift+H".action = move-column-left-or-to-monitor-left;
            "Mod+Shift+J".action = move-window-down-or-to-workspace-down;
            "Mod+Shift+K".action = move-window-up-or-to-workspace-up;
            "Mod+Shift+L".action = move-column-right-or-to-monitor-right;

            "Mod+S".action = toggle-window-floating;

            "Mod+Backspace".action = close-window;
            "Mod+Shift+Backspace".action = close-window;
            "Mod+F".action = maximize-column;

            "Mod+Space".action = noctalia-ipc "launcher" "toggle";
            "Mod+Return".action = spawn (lib.getExe config.programs.alacritty.package);
            "Mod+U".action = spawn (lib.getExe config.programs.zen-browser.package);
            "Mod+C".action = spawn (lib.getExe config.programs.vscode.package);
            "Mod+Comma".action = noctalia-ipc "controlCenter" "toggle";
            "Mod+Shift+Comma".action = noctalia-ipc "settings" "toggle";

            "Mod+F10".action = { screenshot = { show-pointer = false; }; };
            "Mod+Shift+F10".action = { screenshot = { show-pointer = true; }; };

            "Mod+Delete".action = noctalia-ipc "lockScreen" "lock";

            "XF86AudioRaiseVolume".action = noctalia-ipc "volume" "increase";
            "XF86AudioLowerVolume".action = noctalia-ipc "volume" "decrease";
            "XF86AudioMute".action = noctalia-ipc "volume" "muteOutput";
            "XF86MonBrightnessUp".action = noctalia-ipc "brightness" "increase";
            "XF86MonBrightnessDown".action = noctalia-ipc "brightness" "decrease";
          };
      };
    };
  };
}
