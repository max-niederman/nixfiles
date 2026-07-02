{
  config,
  pkgs,
  lib,
  nixosConfig,
  ...
}:

{
  config = lib.mkIf nixosConfig.max.headed {
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
          theme = "capitaine-cursors";
          size = 16;
        };

        layout = {
          empty-workspace-above-first = true;

          preset-column-widths = [
            { proportion = 1. / 4.; }
            { proportion = 1. / 3.; }
            { proportion = 1. / 2.; }
          ];
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
            noctalia-msg = spawn "noctalia" "msg";
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

            "Mod+D".action = switch-preset-column-width;
            "Mod+F".action = maximize-column;

            "Mod+Backspace".action = close-window;
            "Mod+Shift+Backspace".action = close-window;

            "Mod+Space".action = noctalia-msg "panel-toggle" "launcher";
            "Mod+Return".action = spawn (lib.getExe config.programs.alacritty.package);
            "Mod+U".action = spawn (lib.getExe config.programs.zen-browser.package);
            "Mod+C".action = spawn (lib.getExe config.programs.zed-editor.package);
            "Mod+Comma".action = noctalia-msg "panel-toggle" "control-center";
            "Mod+Shift+Comma".action = noctalia-msg "settings-toggle";

            "Mod+V".action = noctalia-msg "panel-toggle" "launcher" "/clipboard";

            "Mod+R".action =
              spawn "sh" "-c"
                "export OPENAI_API_KEY=$(cat /run/secrets/openai_api_key) && pgrep -x waystt >/dev/null && pkill --signal SIGUSR1 waystt || (waystt --pipe-to ydotool type --file - &)";
            "Mod+Shift+R".action =
              spawn "sh" "-c"
                "export OPENAI_API_KEY=$(cat /run/secrets/openai_api_key) && pgrep -x waystt >/dev/null && pkill --signal SIGUSR1 waystt || (waystt --pipe-to wl-copy &)";

            "Mod+F10".action = {
              screenshot = {
                show-pointer = false;
              };
            };
            "Mod+Shift+F10".action = {
              screenshot = {
                show-pointer = true;
              };
            };

            "Mod+Delete".action = noctalia-msg "session" "lock";

            "XF86AudioRaiseVolume".action = noctalia-msg "volume-up";
            "XF86AudioLowerVolume".action = noctalia-msg "volume-down";
            "XF86AudioMute".action = noctalia-msg "volume-mute";
            "XF86MonBrightnessUp".action = noctalia-msg "brightness-up";
            "XF86MonBrightnessDown".action = noctalia-msg "brightness-down";
          };
      };
    };
  };
}
