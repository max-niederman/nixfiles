{ config, pkgs, lib, ... }:

with lib;
{
  imports = [
    ./spacevim.nix
    ./vscode.nix
  ];

  config = mkIf config.max.app.development.enable {
    max.app.development.editor = {
      spacevim.enable = true;
      vscode.enable = config.max.desktop.enable;
    };
  };
}
