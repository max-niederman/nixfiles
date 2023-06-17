{ config, pkgs, lib, ... }:

{
  config = {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      recommendedEnvironment = true;

      extraConfig = ''
        monitor = eDP-1, 1920x1200@60, 0x0, 1

        input {
          kb_layout  = us
          kb_variant = altgr-intl

          follow_mouse = 1

          touchpad {
            natural_scroll = true
          }
        }

        gestures {
          workspace_swipe = true
        }

        misc {
          disable_hyprland_logo = true
          disable_splash_rendering = true
        }

        $mainMod = SUPER

        bind = $mainMod, W, killactive

        bind = $mainMod, Space,  exec, fuzzel
        bind = $mainMod, Return, exec, kitty
        bind = $mainMod, U,      exec, firefox

        bind = $mainMod,       1, workspace, 1
        bind = $mainMod,       2, workspace, 2
        bind = $mainMod,       3, workspace, 3
        bind = $mainMod SHIFT, 1, movetoworkspace, 1
        bind = $mainMod SHIFT, 2, movetoworkspace, 2
        bind = $mainMod SHIFT, 3, movetoworkspace, 3
      '';
    };

    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          prompt = "λ ";
        };
      };
    };
  };
}
