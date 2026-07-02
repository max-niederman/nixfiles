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

  # Anime4K v4.x GLSL shader pipelines, named by the upstream "mode" letters.
  # Source: bloc97/Anime4K official "mpv Configuration Instructions". Each list
  # names files shipped by pkgs.anime4k, which we symlink to ~/.config/mpv/shaders
  # (mpv addresses that as ~~/shaders). "hq" = the recommended higher-end-GPU
  # presets (VL/M CNN kernels); "lite" = the lower-end-GPU presets (M/S kernels).
  anime4kModes = {
    hq = {
      A = [ "Clamp_Highlights" "Restore_CNN_VL" "Upscale_CNN_x2_VL" "AutoDownscalePre_x2" "AutoDownscalePre_x4" "Upscale_CNN_x2_M" ];
      B = [ "Clamp_Highlights" "Restore_CNN_Soft_VL" "Upscale_CNN_x2_VL" "AutoDownscalePre_x2" "AutoDownscalePre_x4" "Upscale_CNN_x2_M" ];
      C = [ "Clamp_Highlights" "Upscale_Denoise_CNN_x2_VL" "AutoDownscalePre_x2" "AutoDownscalePre_x4" "Upscale_CNN_x2_M" ];
      AA = [ "Clamp_Highlights" "Restore_CNN_VL" "Upscale_CNN_x2_VL" "Restore_CNN_M" "AutoDownscalePre_x2" "AutoDownscalePre_x4" "Upscale_CNN_x2_M" ];
      BB = [ "Clamp_Highlights" "Restore_CNN_Soft_VL" "Upscale_CNN_x2_VL" "AutoDownscalePre_x2" "AutoDownscalePre_x4" "Restore_CNN_Soft_M" "Upscale_CNN_x2_M" ];
      CA = [ "Clamp_Highlights" "Upscale_Denoise_CNN_x2_VL" "AutoDownscalePre_x2" "AutoDownscalePre_x4" "Restore_CNN_M" "Upscale_CNN_x2_M" ];
    };
    lite = {
      A = [ "Clamp_Highlights" "Restore_CNN_M" "Upscale_CNN_x2_M" "AutoDownscalePre_x2" "AutoDownscalePre_x4" "Upscale_CNN_x2_S" ];
      B = [ "Clamp_Highlights" "Restore_CNN_Soft_M" "Upscale_CNN_x2_M" "AutoDownscalePre_x2" "AutoDownscalePre_x4" "Upscale_CNN_x2_S" ];
      C = [ "Clamp_Highlights" "Upscale_Denoise_CNN_x2_M" "AutoDownscalePre_x2" "AutoDownscalePre_x4" "Upscale_CNN_x2_S" ];
      AA = [ "Clamp_Highlights" "Restore_CNN_M" "Upscale_CNN_x2_M" "Restore_CNN_S" "AutoDownscalePre_x2" "AutoDownscalePre_x4" "Upscale_CNN_x2_S" ];
      BB = [ "Clamp_Highlights" "Restore_CNN_Soft_M" "Upscale_CNN_x2_M" "AutoDownscalePre_x2" "AutoDownscalePre_x4" "Restore_CNN_Soft_S" "Upscale_CNN_x2_S" ];
      CA = [ "Clamp_Highlights" "Upscale_Denoise_CNN_x2_M" "AutoDownscalePre_x2" "AutoDownscalePre_x4" "Restore_CNN_S" "Upscale_CNN_x2_S" ];
    };
  };

  # An mpv input.conf command that swaps in an Anime4K pipeline and shows a label.
  anime4kBind =
    label: parts:
    ''no-osd change-list glsl-shaders set "${
      lib.concatMapStringsSep ":" (p: "~~/shaders/Anime4K_${p}.glsl") parts
    }"; show-text "${label}"'';
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

      # tar-elendil is a PRIME-offload laptop (Intel primary, NVIDIA offload-only),
      # so a normally-launched mpv renders on the iGPU. Bake the offload env into
      # mpv's wrapper so it always renders on the NVIDIA dGPU: this keeps the heavy
      # Anime4K GLSL shaders fast at 4K and makes hwdec=nvdec's CUDA<->GL interop
      # valid (it requires the renderer to live on the same GPU as the decoder; on
      # the iGPU nvdec silently breaks). These mirror nixos' `nvidia-offload`
      # wrapper, and are mutually exclusive with the package/scripts options (unset).
      extraMakeWrapperArgs = [
        "--set" "__NV_PRIME_RENDER_OFFLOAD" "1"
        "--set" "__NV_PRIME_RENDER_OFFLOAD_PROVIDER" "NVIDIA-G0"
        "--set" "__GLX_VENDOR_LIBRARY_NAME" "nvidia"
        "--set" "__VK_LAYER_NV_optimus" "NVIDIA_only"
      ];

      # Anime4K upscaling/restoration (https://github.com/bloc97/Anime4K), toggled
      # live while a video is focused. Ctrl+1..6 = high-quality presets for the
      # dGPU; Alt+1..6 = lighter presets to save power; Ctrl+0 turns shaders off.
      # Modes: A = restore good sources, B = restore + denoise blurry sources,
      # C = upscale + denoise low-quality sources; doubled (A+A/B+B/C+A) = stronger.
      bindings = {
        "Ctrl+1" = anime4kBind "Anime4K HQ: A (restore)" anime4kModes.hq.A;
        "Ctrl+2" = anime4kBind "Anime4K HQ: B (restore + denoise)" anime4kModes.hq.B;
        "Ctrl+3" = anime4kBind "Anime4K HQ: C (upscale + denoise)" anime4kModes.hq.C;
        "Ctrl+4" = anime4kBind "Anime4K HQ: A+A (heavy restore)" anime4kModes.hq.AA;
        "Ctrl+5" = anime4kBind "Anime4K HQ: B+B (heavy restore + denoise)" anime4kModes.hq.BB;
        "Ctrl+6" = anime4kBind "Anime4K HQ: C+A (upscale + denoise + restore)" anime4kModes.hq.CA;

        "Alt+1" = anime4kBind "Anime4K Lite: A" anime4kModes.lite.A;
        "Alt+2" = anime4kBind "Anime4K Lite: B" anime4kModes.lite.B;
        "Alt+3" = anime4kBind "Anime4K Lite: C" anime4kModes.lite.C;
        "Alt+4" = anime4kBind "Anime4K Lite: A+A" anime4kModes.lite.AA;
        "Alt+5" = anime4kBind "Anime4K Lite: B+B" anime4kModes.lite.BB;
        "Alt+6" = anime4kBind "Anime4K Lite: C+A" anime4kModes.lite.CA;

        "Ctrl+0" = ''no-osd change-list glsl-shaders clr ""; show-text "Anime4K: off"'';
      };
    };

    # Make the Anime4K GLSL files resolvable as ~~/shaders/Anime4K_*.glsl in mpv.
    xdg.configFile."mpv/shaders".source = pkgs.anime4k;

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

      # currently insecure due to outdated Electron
      # bitwarden-desktop

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
