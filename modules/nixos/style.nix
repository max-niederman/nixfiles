{
  config,
  pkgs,
  lib,
  ...
}:

{
  config = lib.mkIf config.max.headed {
    # styling
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      polarity = "dark";
      fonts = {
        serif = {
          package = pkgs.ibm-plex;
          name = "IBM Plex Serif";
        };

        sansSerif = {
          package = pkgs.ibm-plex;
          name = "IBM Plex Sans";
        };

        monospace = {
          package = pkgs.nerd-fonts.fira-code;
          name = "FiraCode Nerd Font";
        };

        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
    };

    # fonts
    fonts = {
      packages = with pkgs; [
        ibm-plex

        source-sans
        source-serif

        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji

        roboto
        roboto-flex

        eb-garamond
        garamond-premier-pro

        nerd-fonts.fira-code
        nerd-fonts.iosevka
      ];

      # use user-specified fonts rather than defaults
      enableDefaultPackages = false;

      fontconfig.defaultFonts = {
        serif = [
          "IBM Plex Serif"
          "Noto Serif CJK"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "IBM Plex Sans"
          "Noto Sans CJK"
          "Noto Color Emoji"
        ];
        monospace = [
          "IBM Plex Mono"
          "Noto Sans Mono CJK"
          "Noto Color Emoji"
        ];
      };

      fontDir.enable = true;
    };
  };
}
