{ config, pkgs, lib, ... }:

{
  config = {
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      recommendedEnvironment = true;

      extraConfig =
        ''
          exec-once = ${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
          exec-once = eww open bar

          # why the fuck is the sleep necessary???
          exec-once = swww init --no-daemon
          exec-once = sleep 1 && swww img -t none ~/Pictures/Wallpapers/$(ls ~/Pictures/Wallpapers | shuf -n 1)

          exec-once = webcord

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

          general {
            gaps_out = 25
            gaps_in = 10

            border_size = 0
          }

          decoration {
            rounding = 8
          }

          misc {
            disable_hyprland_logo = true
            disable_splash_rendering = true
          }

          animations {
            enabled = false
          }

          windowrulev2 = workspace 8, class:^(WebCord)$
          windowrulev2 = workspace 7, clastitle:^(Polaris Simulator)$
          windowrulev2 = float      , clastitle:^(Polaris Simulator)$

          $mainMod = SUPER

          bindm = $mainMod, mouse:272, movewindow
          bindm = $mainMod, mouse:273, resizewindow

          bind = $mainMod, W, killactive
          bind = $mainMod, M, fullscreen

          bind = $mainMod, Space,  exec, fuzzel
          bind = $mainMod, Return, exec, wezterm
          bind = $mainMod, U,      exec, firefox
          bind = $mainMod, C,      exec, code

          bind = ,         Print, exec, grim -g "$(slurp)" - | tee "~/Pictures/Screenshots/$(date -Iseconds).png" | wl-copy --type image/png

          bind = $mainMod, Backspace, exec, wlogout

          ${lib.strings.concatMapStringsSep
              "\n"
              (n: let n' = builtins.toString n;
              in ''
              bind = $mainMod,       ${n'}, workspace, ${n'}
              bind = $mainMod SHIFT, ${n'}, movetoworkspacesilent, ${n'}
            '')
              (lib.lists.range 1 9)}

          bind = $mainMod,       [, workspace, r-1
          bind = $mainMod,       ], workspace, r+1
          bind = $mainMod SHIFT, [, movetoworkspacesilent, r-1
          bind = $mainMod SHIFT, ], movetoworkspacesilent, r+1
        
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

    gtk = {
      enable = true;

      theme = {
        name = "Catppuccin-Macchiato-Standard-Blue-Dark";
        package = pkgs.catppuccin-gtk.override {
          variant = "macchiato";
        };
      };

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "macchiato";
        };
      };

      cursorTheme = {
        name = "Catppuccin-Macchiato-Dark-Cursors";
        package = pkgs.catppuccin-cursors.macchiatoDark;
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
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

    programs.wlogout = {
      enable = true;
      style = ''
        window {
          background-color: 
        }
      '';
    };

    home.packages = with pkgs; [
      grim
      slurp
      hyprpicker
      swww
      pavucontrol

      easyeffects

      webcord-vencord
    ];
  };
}
