{
  pkgs,
  lib,
  config,
  flakeInputs,
  nixosConfig,
  ...
}:

let
  spicePkgs = flakeInputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  config = lib.mkIf nixosConfig.max.headed {
    programs.alacritty = {
      enable = true;
      settings = {
        window.padding = {
          x = 16;
          y = 16;
        };
        font.normal.family = "FiraCode Nerd Font";
      };
    };

    services.easyeffects = {
      enable = true;
    };

    programs.mpv = {
      enable = true;
    };

    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };
    stylix.targets.spicetify.enable = false;

    # for Vesktop
    services.arrpc = {
      enable = true;
    };

    # use bitwarden desktop's ssh agent
    home.sessionVariables.SSH_AUTH_SOCK = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";

    home.packages = with pkgs; [
      qpwgraph

      bitwarden-desktop

      anki

      audacity

      vesktop
      slack
      zoom-us

      jellyfin-mpv-shim

      osu-lazer-bin
      prismlauncher

      waystt
    ];
  };
}
