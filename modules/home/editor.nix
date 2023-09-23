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
        ms-vsliveshare.vsliveshare

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

        # Haskell
        haskell.haskell
        justusadam.language-haskell

        # C/C++
        ms-vscode.cpptools
        ms-vscode.cmake-tools

        # Go
        golang.go

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
        "workbench.iconTheme" = "material-icon-theme";
        # "workbench.productIconTheme" = "material-product-icons";

        "editor.lineNumbers" = "relative";
        "editor.acceptSuggestionOnEnter" = "smart";
        "editor.inlineSuggest.enabled" = true;

        "direnv.path.executable" = "${pkgs.direnv}/bin/direnv";

        "python.languageServer" = "Pylance";
        "python.formatting.provider" = "black";

        "haskell.manageHLS" = "PATH";

        "nix.serverPath" = "${pkgs.nil}/bin/nil";

        "[jsonc]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[typescriptreact]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };

        "files.associations" = {
          "*.mdx" = "markdown";
        };
      };
    };

    home.packages = with pkgs; [
      neovim

      jetbrains.idea-ultimate
      android-studio
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
