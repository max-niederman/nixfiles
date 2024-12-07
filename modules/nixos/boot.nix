{
  config,
  pkgs,
  lib,
  ...
}:

{
  config = {
    boot.plymouth = {
      enable = true;
      themePackages = with pkgs; [ catppuccin-plymouth ];
      theme = "catppuccin-macchiato";
      font = "${pkgs.ibm-plex}/share/fonts/opentype/IBMPlexMono-Regular.otf";
    };
  };
}
