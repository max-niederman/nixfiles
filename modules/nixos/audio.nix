{
  config,
  pkgs,
  lib,
  ...
}:

{
  config = lib.mkIf config.max.headed {
    # audio
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    security.rtkit.enable = true;
  };
}
