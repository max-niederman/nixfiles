{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.shell;
in
{
  options.max.shell = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable shell configuration.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      thefuck

      # Utilities
      neofetch
      wget
      unzip
    ];

    programs = {
      # Shells
      fish = {
        enable = true;

        shellInit = ''
          thefuck --alias | source
        '';
        promptInit = ''
          starship init fish | source
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

      # Prompts
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

      # Utilities

      lsd = {
        enable = true;
        enableAliases = true;
      };

      direnv = {
        enable = true;

        nix-direnv = {
          enable = true;
          enableFlakes = true;
        };

        enableFishIntegration = true;
        enableBashIntegration = true;
      };

      gpg.enable = true;
      bat.enable = true;
    };
  };
}
