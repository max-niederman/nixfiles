{ config, pkgs, ... }:

{
  config = {
    programs.git = {
      enable = true;

      lfs.enable = true;
      delta.enable = true;

      userEmail = "max@maxniederman.com";
      userName = "Max Niederman";

      signing = {
        key = null; # let GPG decide
        gpgPath = "${config.programs.gpg.package}/bin/gpg2";
        signByDefault = true;
      };

      extraConfig = {
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
      '';
    };
    services.lorri = {
      enable = true;
    };

    home.packages = with pkgs; [
      gh
      git-crypt # transparent file encryption

      lldb
      gdb
      lurk
      hyperfine

      gcc

      python311
      poetry
      black

      rustup
      cargo-generate
      cargo-flamegraph
      cargo-depgraph
      cargo-nextest

      ghc
      cabal-install
      haskell-language-server

      julia-bin

      jdk

      nixpkgs-fmt

      sqlite
      sqlite-utils

      httpie

      graphviz
    ];
  };
}
