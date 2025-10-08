{ config, pkgs, lib, ... }:

{
  config = {
    programs.niri = {
      enable = true;
      settings = {
        binds = with config.lib.niri.actions; {
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
          "Mod+F".action = fullscreen-window;

          "Mod+Space".action = spawn "fuzzel";
          "Mod+Return".action = spawn "alacritty";
          "Mod+U".action = spawn "zen";
          "Mod+C".action = spawn "code";

          # "Mod+Print".action = spawn "grim -g $(slurp) - | tee $HOME/Pictures/Screenshots/$(date -Iseconds).png | wl-copy --type image/png";
          "Mod+Print".action = screenshot { show-pointer = false; };
          "Mod+Shift+Print".action = screenshot { show-pointer = true; };

          "Mod+Delete".action = spawn "wlogout";
        };
      };
    };
  };
}