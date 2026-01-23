{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./wm.nix
    ./shell.nix
    ./apps.nix
    ./browser.nix
  ];

  config = {
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
    };

    gtk = {
      enable = true;
    };

    home.file."Pictures/Wallpapers" = {
      source = ./wallpapers;
    };

    services.micromanage = {
      enable = true;
      monitorIdentifier = "Dell Inc. DELL U4025QW J8M9484";
      people = [
        "Akshar"
        "Data"
        "Stephen"
        "Tejas"
        "Harish"
      ];
      interval = "hourly";
    };

    home.packages = with pkgs; [
      # clipboard utilities
      wl-clipboard

      # color picker
      hyprpicker

      # audio
      pavucontrol
    ];
  };
}
