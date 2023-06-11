{ config, pkgs, lib, ... }:

{
  config = {
    programs.nushell = {
      enable = true;
    };

    programs.fish = {
      enable = true;

      plugins = map
        (p: {
          name = lib.strings.removePrefix "fishplugin-" p.name;
          src = p.src;
        })
        (with pkgs.fishPlugins; [
          pisces
          z
          sponge
          colored-man-pages
        ]);
    };

    programs.starship = {
      enable = true;

      enableNushellIntegration = true;
      enableFishIntegration = true;
      enableBashIntegration = true;

      settings = {
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
  };
}
