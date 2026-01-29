{
  config,
  pkgs,
  lib,
  ...
}:

{
  config = lib.mkIf config.max.headed {
    # greeter
    services.greetd = {
      enable = config.max.headed;
      settings = {
        default_session = {
          command = ''
            ${pkgs.tuigreet}/bin/tuigreet \
              --cmd /run/current-system/sw/bin/niri-session \
              --remember \
              --remember-session \
              --asterisks \
              --power-shutdown "systemctl poweroff" \
              --power-reboot "systemctl reboot" \
              --window-padding 4 \
              --container-padding 4
          '';
          user = "greeter";
        };
      };
    };

    # window manager
    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };

    # shell
    services.noctalia-shell.enable = true;

    # core XDG stuff
    xdg = {
      mime.enable = true;
      icons.enable = true;
      portal = {
        enable = true;
        extraPortals = [
          # Enable three different portals for improved compatibility
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-gnome
          pkgs.xdg-desktop-portal-wlr
        ];
      };
    };
    environment.systemPackages = with pkgs; [
      xdg-utils # for stuff like xdg-open
    ];

    # security
    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;

    # random device drivers
    services.printing.enable = true;
  };
}
