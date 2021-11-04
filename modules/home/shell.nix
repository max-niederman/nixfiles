{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.shell;
in
{
  config = {
    home.packages = with pkgs; [ thefuck tealdeer ];

    programs = {
      # Shell
      fish = {
        enable = true;

        shellInit = ''
          ${pkgs.thefuck}/bin/thefuck --alias | source
        '';
        promptInit = ''
          ${pkgs.starship}/bin/starship init fish | source
        '';

        shellAbbrs = {
          "vim" = "spacevim";
        };

        plugins = [
          {
            name = "ssh-agent";
            src = pkgs.fetchFromGitHub {
              owner = "danhper";
              repo = "fish-ssh-agent";
              rev = "fd70a2afdd03caf9bf609746bf6b993b9e83be57";
              sha256 = "1fvl23y9lylj4nz6k7yfja6v9jlsg8jffs2m5mq0ql4ja5vi5pkv";
            };
          }
        ];
      };

      # Prompt
      starship = {
        enable = true;

        enableFishIntegration = true;
        enableBashIntegration = true;

        settings.character = {
          success_symbol = "[λ](bold green)";
          error_symbol = "[λ](bold red)";
          vicmd_symbol = "[λ](bold yellow)";
        };
      };
    };
  };
}
