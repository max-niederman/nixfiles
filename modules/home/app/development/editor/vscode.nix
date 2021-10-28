{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.app.development.editor.vscode;
in
{
  options.max.app.development.editor.vscode = {
    enable = mkEnableOption "Enable VS Code.";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
    };
  };
}
