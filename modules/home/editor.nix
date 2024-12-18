{
  config,
  pkgs,
  lib,
  ...
}:

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

        # sourcegraph.cody-ai
        github.copilot
        github.copilot-chat

        catppuccin.catppuccin-vsc
        pkief.material-icon-theme
        pkief.material-product-icons

        github.vscode-pull-request-github
        github.vscode-github-actions
        github.codespaces

        wakatime.vscode-wakatime
        icrawl.discord-vscode

        vadimcn.vscode-lldb

        ms-vscode.hexeditor
        tamasfe.even-better-toml
        ms-azuretools.vscode-docker

        # Markdown
        yzhang.markdown-all-in-one
        davidanson.vscode-markdownlint
        marp-team.marp-vscode

        # Typst
        myriad-dreamin.tinymist
        tomoki1207.pdf

        # LaTeX
        james-yu.latex-workshop

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

        # Julia
        julialang.language-julia

        # Clojure
        betterthantomorrow.calva

        # C/C++
        ms-vscode.cpptools-extension-pack

        # Go
        golang.go

        # Web
        ritwickdey.liveserver
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        svelte.svelte-vscode
        astro-build.astro-vscode

        # Java
        redhat.java
        vscjava.vscode-java-debug
        vscjava.vscode-java-test
        vscjava.vscode-gradle

        # Lean
        pkgs.vscode-marketplace.leanprover.lean4
      ];

      userSettings = {
        "window.titleBarStyle" = "custom";

        "editor.fontFamily" = "FiraCode Nerd Font";
        "editor.fontLigatures" = true;
        "editor.fontSize" = 16;

        "workbench.colorTheme" = "Catppuccin Macchiato";
        "workbench.iconTheme" = "material-icon-theme";
        # "workbench.productIconTheme" = "material-product-icons";

        "editor.lineNumbers" = "relative";
        "editor.acceptSuggestionOnEnter" = "smart";
        "editor.inlineSuggest.enabled" = true;

        "git.confirmSync" = false;

        "cody.autocomplete.advanced.provider" = "experimental-ollama";
        "cody.experimental.ollamaChat" = true;
        "cody.autocomplete.experimental.ollamaOptions" = {
          "url" = "http://localhost:11434";
          "model" = "codellama";
        };

        "terminal.integrated.profiles.linux" = {
          "nu" = {
            path = "/run/current-system/sw/bin/nu";
          };
        };
        "terminal.integrated.defaultProfile.linux" = "nu";

        "direnv.path.executable" = "${pkgs.direnv}/bin/direnv";

        "python.languageServer" = "Pylance";
        "python.formatting.provider" = "black";

        "haskell.manageHLS" = "PATH";

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nil}/bin/nil";

        "svelte.enable-ts-plugin" = true;

        "[markdown]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[json]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[jsonc]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[typescript]" = {
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

      typst
      tinymist
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
