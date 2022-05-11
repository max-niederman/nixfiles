{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.development;
in
{
  imports = [
    (fetchTarball {
      url = "https://github.com/msteen/nixos-vscode-server/tarball/d2343b5eb47b811856085f3eff4d899a32b2c136";
      sha256 = "1cszfjwshj6imkwip270ln4l1j328aw2zh9vm26wv3asnqlhdrak";
    })
  ];

  options.max.development = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable system-wide development software and configurations.";
    };

    editor.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable text editors.";
    };

    docker.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Docker virtualisation";
    };

    vscode-server.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable VS Code remote server";
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = mkIf cfg.editor.enable {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    virtualisation.docker.enable = cfg.docker.enable;

    services.vscode-server.enable = cfg.vscode-server.enable;
  };
}
