{ pkgs, ... }:

{
  config = {
    programs.nushell = {
      enable = true;
      configFile.text = ''
        $env.config = {
            show_banner: false,
            completions: {
                case_sensitive: false,
                quick: true,
                partial: true,
                algorithm: 'fuzzy',
            }
        }
      '';
    };

    programs.bash = {
      enable = true;
    };

    programs.starship = {
      enable = true;

      enableNushellIntegration = true;
      enableBashIntegration = true;

      settings = {
        shell.disabled = false;

        aws.disabled = true;
        azure.disabled = true;
        gcloud.disabled = true;

        character = {
          success_symbol = "[λ](bold green)";
          error_symbol = "[λ](bold red)";
          vicmd_symbol = "[λ](bold yellow)";
        };
      };
    };
    catppuccin.starship.enable = true;

    programs.bat = {
      enable = true;
    };
    catppuccin.bat.enable = true;

    programs.alacritty = {
      enable = true;
      settings = {
        shell = "/run/current-system/sw/bin/nu";
        window.padding = {
          x = 16;
          y = 16;
        };
        font.normal.family = "FiraCode Nerd Font";
      };
    };
    catppuccin.alacritty.enable = true;

    programs.carapace = {
      enable = true;
    };

    programs.zoxide = {
      enable = true;
    };

    home.packages = with pkgs; [
      # fetch
      fastfetch
      cpufetch

      # resource monitor
      htop
      iftop

      # network utilities
      iputils
      dogdns
      nmap
      caddy
      mtr

      # misc. utilities
      ripgrep
      file
      libtree
    ];
  };
}
