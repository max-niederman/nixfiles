{ config, pkgs, lib, ... }:

{
  config = {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [ fcitx5-mozc ];
    };

    services = {
      interception-tools = {
        enable = true;
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

      gnome.gnome-keyring.enable = true;
    };
  };
}
