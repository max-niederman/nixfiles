{ config, pkgs, lib, ... }:

{
  config = {
    programs.vscode = {
      enable = true;

      enableExtensionUpdateCheck = true;
      enableUpdateCheck = false;

      mutableExtensionsDir = false;
      extensions = with pkgs.vscode-extensions; [
        mkhl.direnv
        editorconfig.editorconfig

        vscodevim.vim

        github.copilot

        jdinhlife.gruvbox
        pkief.material-icon-theme
        pkief.material-product-icons

        github.vscode-pull-request-github
        github.codespaces
        wakatime.vscode-wakatime

        vadimcn.vscode-lldb

        ms-vscode.hexeditor
        tamasfe.even-better-toml
        ms-azuretools.vscode-docker

        # Markdown
        yzhang.markdown-all-in-one
        davidanson.vscode-markdownlint
        marp-team.marp-vscode

        # Typst
        nvarner.typst-lsp
        tomoki1207.pdf

        # Nix
        jnoortheen.nix-ide

        # Shell
        thenuprojectcontributors.vscode-nushell-lang

        # Rust
        rust-lang.rust-analyzer
        serayuzgur.crates

        # Python
        ms-python.python
        ms-python.vscode-pylance
        ms-pyright.pyright

        # Haskell
        haskell.haskell

        # Web
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        svelte.svelte-vscode
        astro-build.astro-vscode
      ];

      userSettings = {
        "editor.fontFamily" = "FiraCode Nerd Font";
        "editor.fontLigatures" = true;
        "editor.fontSize" = 16;
        "workbench.colorTheme" = "Gruvbox Dark Hard";
        "workbench.iconTheme" = "material";
        "workbench.productIconTheme" = "material";

        "editor.lineNumbers" = "relative";
        "editor.acceptSuggestionOnEnter" = "smart";
        "editor.inlineSuggest.enabled" = true;

        "python.languageServer" = "Pylance";
        "python.formatting.provider" = "black";

        "nix.serverPath" = "${pkgs.nil}/bin/nil";

        "[jsonc]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
      };
    };
  };
}
