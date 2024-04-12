{ config, osConfig, pkgs, lib, ... }:

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

        source ${pkgs.atuin.src}/atuin/src/shell/atuin.nu
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

    programs.wezterm = {
      enable = true;
      extraConfig = ''
        local wezterm = require 'wezterm'

        local config = wezterm.config_builder()

        config.default_prog = { "/run/current-system/sw/bin/nu" }

        config.enable_wayland = false

        config.hide_tab_bar_if_only_one_tab = true

        config.font = wezterm.font 'FiraCode Nerd Font'
        config.color_scheme = 'Catppuccin Macchiato'

        return config
      '';
    };

    programs.carapace = {
      enable = true;
    };

    home.packages = with pkgs; [
      # assumed ambient by config
      atuin

      # fetch
      neofetch
      pfetch-rs
      cpufetch

      # resource monitor
      htop
      iftop
      nvtop

      # network utilities
      iputils
      dnsutils
      nmap
      caddy
      dublin-traceroute

      # misc. utilities
      ripgrep
      file
    ];
  };
}
