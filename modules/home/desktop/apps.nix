{
  pkgs,
  lib,
  config,
  flakeInputs,
  nixosConfig,
  ...
}:

let
  spicePkgs = flakeInputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  config = lib.mkIf nixosConfig.max.headed {
    programs.alacritty = {
      enable = true;
      settings = {
        window.padding = {
          x = 16;
          y = 16;
        };
        font.normal.family = "FiraCode Nerd Font";
      };
    };

    services.easyeffects = {
      enable = true;
    };

    programs.mpv = {
      enable = true;
      config = {
        # NVIDIA + Wayland: Vulkan WSI loses surfaces (VK_ERROR_SURFACE_LOST_KHR)
        # on compositor events (DPMS, VRR transitions, pause). OpenGL is stable.
        vo = "gpu";
        gpu-api = "opengl";
        gpu-context = "wayland";
        hwdec = "nvdec";
      };
    };

    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };
    stylix.targets.spicetify.enable = false;

    # for Vesktop
    services.arrpc = {
      enable = true;
    };

    # use bitwarden desktop's ssh agent
    home.sessionVariables.SSH_AUTH_SOCK = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";

    # Several apps over-claim MIME types in their .desktop files, so xdg-open
    # picks a poor default (Prism Launcher grabbed application/zip for Minecraft
    # modpacks; Audacity, an editor, grabbed audio playback; Chromium grabbed
    # images and PDFs). Pin the ones we care about here.
    #
    # These are merged into ~/.config/mimeapps.list via xdg-mime rather than
    # having home-manager own that file, because it's written at runtime by the
    # browser/vesktop/etc. to register their URL-scheme handlers. Clearing
    # XDG_CURRENT_DESKTOP makes the entries land in the plain mimeapps.list (the
    # authoritative file the resolver reads).
    home.activation.fixMimeDefaults =
      let
        setDefault = "env XDG_CURRENT_DESKTOP= ${pkgs.xdg-utils}/bin/xdg-mime default";
      in
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        # archives -> file-roller (Prism Launcher had claimed application/zip)
        run ${setDefault} org.gnome.FileRoller.desktop application/zip
        # audio -> mpv (was opening in Audacity, an editor)
        run ${setDefault} mpv.desktop audio/mpeg audio/flac audio/x-flac audio/x-wav audio/wav audio/ogg audio/x-vorbis+ogg audio/aac audio/mp4 audio/x-m4a audio/opus audio/webm
        # images + PDF -> browser (were opening in Chromium)
        run ${setDefault} zen-beta.desktop image/png image/jpeg image/gif image/webp image/svg+xml image/avif image/bmp image/tiff application/pdf
        # json -> editor (had no default at all)
        run ${setDefault} dev.zed.Zed.desktop application/json
      '';

    home.packages = with pkgs; [
      qpwgraph

      # file manager + archive manager (file-roller handles .zip; see above)
      nautilus
      file-roller

      bitwarden-desktop

      anki

      audacity

      vesktop
      slack
      zoom-us

      jellyfin-mpv-shim

      osu-lazer-bin
      prismlauncher

      waystt
    ];
  };
}
