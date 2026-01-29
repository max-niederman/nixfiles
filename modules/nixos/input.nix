{
  config,
  pkgs,
  lib,
  ...
}:

{
  config = {
    # input devices
    services.interception-tools = {
      enable = config.max.headed;
      plugins = with pkgs.interception-tools-plugins; [ caps2esc ];

      # until nixpkgs#126681 is fixed, we need to manually specify the binary paths
      udevmonConfig =
        let
          tools = pkgs.interception-tools;
          plugins = pkgs.interception-tools-plugins;
        in
        ''
          - JOB: "${tools}/bin/intercept -g $DEVNODE | ${plugins.caps2esc}/bin/caps2esc | ${tools}/bin/uinput -d $DEVNODE"
            DEVICE:
              EVENTS:
                EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
        '';
    };
    hardware.opentabletdriver.enable = config.max.headed;

    # ydotool
    programs.ydotool = {
      enable = true;
      group = "wheel";
    };
  };
}
