{ config, pkgs, lib, ... }:

{
  config = {
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      recommendedEnvironment = true;

      extraConfig = ''
        exec-once = ${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
        exec-once = eww open bar

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

        animations {
          enabled = false
        }

        $mainMod = SUPER

        bind = $mainMod, W, killactive
        bind = $mainMod, M, fullscreen

        bind = $mainMod, Space,  exec, fuzzel
        bind = $mainMod, Return, exec, kitty
        bind = $mainMod, U,      exec, firefox

        bind = ,         Print, exec, grim -g "$(slurp)" ~/Pictures/Screenshots/$(date -Iseconds).png

        ${lib.strings.concatMapStringsSep
          "\n"
          (n: let n' = builtins.toString n; in ''
            bind = $mainMod,       ${n'}, workspace, ${n'}
            bind = $mainMod SHIFT, ${n'}, movetoworkspace, ${n'}
          '')
          (lib.lists.range 1 9)}
        
        bind = $mainMod,       H, movefocus, l
        bind = $mainMod,       J, movefocus, d
        bind = $mainMod,       K, movefocus, u
        bind = $mainMod,       L, movefocus, r
        bind = $mainMod SHIFT, H, movewindow, l
        bind = $mainMod SHIFT, J, movewindow, d
        bind = $mainMod SHIFT, K, movewindow, u
        bind = $mainMod SHIFT, L, movewindow, r

        bind = $mainMod,       S, togglefloating
      '';
    };

    programs.eww = {
      enable = true;
      package = pkgs.eww-wayland;
      configDir = ./eww;
    };

    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          prompt = "λ";
        };
      };
    };

    programs.firefox = {
      enable = true;
    };

    home.packages = with pkgs; [
      grim
      slurp
      hyprpicker
    ];
  };
}
