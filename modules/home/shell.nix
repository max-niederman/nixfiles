{ pkgs, ... }:

{
  config = {
    programs.nushell = {
      enable = true;
      configFile.text = ''
        $env.config = {
            show_banner: false,
            completions: {
                case_sensitive: false,
                quick: true,
                partial: true,
                algorithm: 'fuzzy',
            }
        }

        # Open a zoxide-resolved directory in Zed.
        # `ze <query>` jumps via the zoxide database and opens the result in Zed,
        # e.g. `ze -n nixfiles` opens the nixfiles dir in a new window. Like `z`,
        # an existing local path is opened directly rather than queried. All zeditor
        # flags are declared below so they tab-complete and show in `help ze`.
        def ze [
            ...query: directory         # local path or zoxide query (completes dirs like `cd`)
            --wait(-w)                  # Wait for paths to be opened/closed before exiting
            --add(-a)                   # Add files to the currently open workspace
            --new(-n)                   # Create a new workspace
            --existing(-e)              # Open in existing Zed window
            --foreground                # Run zed in the foreground (useful for debugging)
            --version(-v)               # Print Zed's version and the app path
            --system-specs              # Print system specs
            --dev-container             # Open the project in a dev container
            --user-data-dir: string     # Custom directory for all user data
            --zed: string               # Custom path to Zed.app or the zed binary
            --dev-server-token: string  # Run zed in dev-server mode
        ] {
            let bool_flags = [
                (if $wait { "--wait" })
                (if $add { "--add" })
                (if $new { "--new" })
                (if $existing { "--existing" })
                (if $foreground { "--foreground" })
                (if $version { "--version" })
                (if $system_specs { "--system-specs" })
                (if $dev_container { "--dev-container" })
            ] | compact
            let value_flags = [
                (if $user_data_dir != null { ["--user-data-dir" $user_data_dir] })
                (if $zed != null { ["--zed" $zed] })
                (if $dev_server_token != null { ["--dev-server-token" $dev_server_token] })
            ] | compact | flatten
            # Like `z`: open an existing local dir directly, otherwise query zoxide.
            let arg0 = ($query | append '~' | first)
            let dir = if (($query | length) <= 1) and (($arg0 | path expand | path type) == 'dir') {
                $arg0
            } else {
                (zoxide query ...$query | str trim)
            }
            zeditor ...$bool_flags ...$value_flags $dir
        }
      '';
    };

    programs.bash = {
      enable = true;
    };

    programs.starship = {
      enable = true;

      enableNushellIntegration = true;
      enableBashIntegration = true;

      settings = {
        shell.disabled = false;

        aws.disabled = true;
        azure.disabled = true;
        gcloud.disabled = true;

        character = {
          success_symbol = "[λ](bold green)";
          error_symbol = "[λ](bold red)";
          vicmd_symbol = "[λ](bold yellow)";
        };
      };
    };

    programs.bat = {
      enable = true;
    };

    programs.carapace = {
      enable = true;
    };

    programs.zoxide = {
      enable = true;
    };

    home.packages = with pkgs; [
      # credentials
      bitwarden-cli

      # fetch
      fastfetch
      cpufetch

      # resource monitor
      htop
      iftop

      # network utilities
      iputils
      unixtools.netstat
      doggo
      nmap
      caddy
      mtr

      # misc. utilities
      ripgrep
      jq
      file
      libtree
      ffmpeg
    ];
  };
}
