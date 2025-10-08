{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [ ./wm.nix ./apps.nix ];

  config = {
    wayland.windowManager.hyprland = {
      enable = true;

      extraConfig = ''
        exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
        exec-once = fcitx5
        exec-once = ${pkgs.swaynotificationcenter}/bin/swaync
        exec-once = ${pkgs.swayosd}/bin/swayosd-server
        exec-once = waypaper --restore --backend swww

        env = GTK_IM_MODULE,fcitx
        env = QT_IM_MODULE,fcitx
        env = XMODIFIERS,@im=fcitx

        input {
          kb_layout  = us
          kb_variant = altgr-intl

          follow_mouse = 1

          touchpad {
            natural_scroll = true
          }
        }

        general {
          gaps_out = 25
          gaps_in = 10

          border_size = 0
        }

        cursor {
          no_warps = true
        }

        decoration {
          rounding = 8
        }

        misc {
          disable_hyprland_logo = true
          disable_splash_rendering = true
        }

        $mainMod = SUPER

        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod, mouse:273, resizewindow

        bind = $mainMod, Backspace, killactive
        bind = $mainMod, M,      fullscreen

        bind = $mainMod, Space,  exec, fuzzel
        bind = $mainMod, Return, exec, alacritty
        bind = $mainMod, U,      exec, zen
        bind = $mainMod, C,      exec, code

        bind = ,         Print, exec, grim -g "$(slurp)" - | tee "$HOME/Pictures/Screenshots/$(date -Iseconds).png" | wl-copy --type image/png

        bind = $mainMod, Delete, exec, wlogout

        ${lib.strings.concatMapStringsSep "\n" (
          n:
          let
            n' = builtins.toString n;
          in
          ''
            bind = $mainMod,       ${n'}, workspace, ${n'}
            bind = $mainMod SHIFT, ${n'}, movetoworkspacesilent, ${n'}
          ''
        ) (lib.lists.range 1 9)}

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

        binde = , XF86AudioRaiseVolume,  exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume 5
        binde = , XF86AudioLowerVolume,  exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume -5
        binde = , XF86MonBrightnessUp,   exec, ${pkgs.brightnessctl}/bin/brightnessctl s +5%
        binde = , XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 5%-
      '';
    };

    gtk = {
      enable = true;
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    home.file."Pictures/Wallpapers" = {
      source = ./wallpapers;
    };

    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          prompt = "λ";
        };
      };
    };

    programs.wlogout = {
      enable = true;
      style = ''
        window {
          background-color: rgba(0, 0, 0, 0);
        }

        button {
          border-radius: 0;
          border-color: black;
          text-decoration-color: #cad3f5;
          color: #cad3f5;
          background-color: #24273a;
          border-style: solid;
          border-width: 1px;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;
        }

        button:focus, button:active {
          color: #24273a;
          background-color: #c6a0f6;
          outline-style: none;
        }

        #lock {
            background-image: image(url("${config.programs.wlogout.package}/share/wlogout/icons/lock.png"));
        }

        #logout {
            background-image: image(url("${config.programs.wlogout.package}/share/wlogout/icons/logout.png"));
        }

        #suspend {
            background-image: image(url("${config.programs.wlogout.package}/share/wlogout/icons/suspend.png"));
        }

        #hibernate {
            background-image: image(url("${config.programs.wlogout.package}/share/wlogout/icons/hibernate.png"));
        }

        #shutdown {
            background-image: image(url("${config.programs.wlogout.package}/share/wlogout/icons/shutdown.png"));
        }

        #reboot {
            background-image: image(url("${config.programs.wlogout.package}/share/wlogout/icons/reboot.png"));
        }
      '';
    };

    programs.hyprlock = {
      enable = true;
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || ${config.programs.hyprlock.package}/bin/hyprlock";
          before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
          after_sleep_cmd = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = 300; # 5 minutes
            on-timeout = "${pkgs.libnotify}/bin/notify-send 'Idle' 'You have been idle for 5 minutes.'";
          }
          {
            timeout = 600; # 10 minutes
            on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
          }
          {
            timeout = 720; # 12 minutes
            on-timeout = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms off";
            on-resume = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on";
          }
          {
            timeout = 1500; # 25 minutes
            on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
          }
        ];
      };
    };

    home.packages = with pkgs; [
      # clipboard utilities
      wl-clipboard

      # screenshots
      grim
      slurp

      # color picker
      hyprpicker

      # wallpaper
      swww
      waypaper

      # audio
      pavucontrol
    ];
  };
}
