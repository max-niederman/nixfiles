{ config, osConfig, pkgs, lib, ... }:

{
  config = {
    programs.nushell = {
      enable = true;
      envFile.source = ./nu/env.nu;
      configFile.source = ./nu/config.nu;

      environmentVariables = lib.attrsets.mapAttrs
        (n: v: ''"${v}"'')
        {
          inherit (osConfig.environment.variables)
            GTK_IM_MODULE
            QT_IM_MODULE
            XMODIFIERS;
        };
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
      extraConfig = builtins.readFile ./wezterm/wezterm.lua;
    };

    home.packages = with pkgs; [
      carapace

      htop
      neofetch
    ];
  };
}
