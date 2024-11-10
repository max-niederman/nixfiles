{ lib, config, pkgs, ... }:

{
  config = {
    programs.git = {
      enable = true;

      lfs.enable = true;
      delta =  {
        enable = true;
        catppuccin.enable = true;
      };

      userEmail = "max@maxniederman.com";
      userName = "Max Niederman";

      signing = {
        key = "~/.ssh/id_ed25519.pub";
        signByDefault = true;
      };

      extraConfig = {
        gpg.format = "ssh";
        gpg.ssh.allowedSignersFile = toString (pkgs.writeText "allowed-signers" ''
          max@maxniederman.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINmdKg6WzEiyKysklc3YAKLjHEDLZq4RAjRYlSVbwHs9 max
        '');
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    programs.direnv = {
      enable = true;
      stdlib = ''
        layout_poetry() {
          PYPROJECT_TOML="${"\${PYPROJECT_TOML:-pyproject.toml}"}"
          if [[ ! -f "$PYPROJECT_TOML" ]]; then
            log_status "No pyproject.toml found. Executing \`poetry init\` to create a \`$PYPROJECT_TOML\` first."
            poetry init
          fi

          if [[ -d ".venv" ]]; then
            VIRTUAL_ENV="$(pwd)/.venv"
          else
            VIRTUAL_ENV=$(poetry env info --path 2>/dev/null ; true)
          fi

          if [[ -z $VIRTUAL_ENV || ! -d $VIRTUAL_ENV ]]; then
            log_status "No virtual environment exists. Executing \`poetry install\` to create one."
            poetry install
            VIRTUAL_ENV=$(poetry env info --path)
          fi

          PATH_add "$VIRTUAL_ENV/bin"
          export POETRY_ACTIVE=1
          export VIRTUAL_ENV
        }

        layout_uv() {
          if [[ -d ".venv" ]]; then
            VIRTUAL_ENV="$(pwd)/.venv"
          fi

          if [[ -z $VIRTUAL_ENV || ! -d $VIRTUAL_ENV ]]; then
            log_status "No virtual environment exists. Executing \`uv venv\` to create one."
            uv venv
            VIRTUAL_ENV="$(pwd)/.venv"
          fi

          PATH_add "$VIRTUAL_ENV/bin"
          export UV_ACTIVE=1  # or VENV_ACTIVE=1
          export VIRTUAL_ENV
        }
      '';
    };

    # thanks Nilstrieb!
    # mold-wrapped has the cursed nix linker shenanigans that make it produce properly rpathed binaries.
    home.file.".cargo/config.toml".text = ''
      [target.x86_64-unknown-linux-gnu]
      linker = "${lib.getExe pkgs.llvmPackages_16.clang}"
      rustflags = ["-Clink-arg=-fuse-ld=${lib.getExe' pkgs.mold-wrapped "mold"}", "-Ctarget-cpu=native"]
    '';

    home.packages = with pkgs; [
      gh
      git-crypt # transparent file encryption

      lldb
      gdb
      lurk
      hyperfine

      gcc

      python311
      uv
      black

      rustup
      cargo-generate
      cargo-flamegraph
      cargo-depgraph
      cargo-nextest

      ghc
      cabal-install
      haskell-language-server

      jdk

      lean4

      nixpkgs-fmt

      sqlite
      sqlite-utils

      httpie

      graphviz
    ];
  };
}
