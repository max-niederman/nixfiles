{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.font;

  selectionOpts = with types; {
    packages = mkOption {
      type = listOf package;
      example = pkgs.noto-fonts;
    };

    name = mkOption {
      type = str;
      example = "Noto Sans";
    };
  };
in
{
  options.max.font = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable font configuration.";
    };

    selections = {
      default = mkOption {
        type = types.submodule selectionOpts;
        default = {
          packages = with pkgs; [
            noto-fonts
            noto-fonts-cjk
            noto-fonts-emoji
          ];
          name = "Noto Sans";
        };
      };

      decoration = mkOption {
        type = types.submodule selectionOpts;
        default = let name = "Iosevka"; in
          {
            packages = [ (pkgs.nerdfonts.override { fonts = [ name ]; }) ];
            name = "${name} Nerd Font";
          };
      };

      code = mkOption {
        type = types.submodule selectionOpts;
        default = let name = "FiraCode"; in
          {
            packages = [ (pkgs.nerdfonts.override { fonts = [ name ]; }) ];
            name = "${name} Nerd Font";
          };
      };
    };
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages = flatten (mapAttrsToList (selection: font: font.package) cfg.selections);
  };
}
