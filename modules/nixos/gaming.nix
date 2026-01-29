{
  config,
  pkgs,
  lib,
  ...
}:

{
  config = lib.mkIf config.max.gaming {
    programs.steam = {
      enable = true;
    };
  };
}
