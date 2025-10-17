{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./wm.nix
    ./apps.nix
    ./browser.nix
  ];

  config = {
    gtk = {
      enable = true;
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

    home.packages = with pkgs; [
      # clipboard utilities
      wl-clipboard

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
