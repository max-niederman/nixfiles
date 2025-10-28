{
  pkgs,
  lib,
  ...
}:

{
  config = {
    programs.vscode = {
      enable = true;

      package = pkgs.code-cursor;

      mutableExtensionsDir = true;

      profiles.default = {
        enableExtensionUpdateCheck = true;
        enableUpdateCheck = false;

        extensions = with pkgs.vscode-extensions; [
          mkhl.direnv
          editorconfig.editorconfig

          vscodevim.vim
          ms-vsliveshare.vsliveshare

          catppuccin.catppuccin-vsc
          pkief.material-icon-theme
          pkief.material-product-icons

          github.vscode-pull-request-github
          github.vscode-github-actions
          github.codespaces

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
          # we unfortunately need to install these manually because they're not on the marketplace
          # anysphere.pyright
          # anysphere.cursorpyright

          # Haskell
          haskell.haskell
          justusadam.language-haskell

          # Julia
          # julialang.language-julia

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

          "workbench.iconTheme" = "material-icon-theme";
          "workbench.colorTheme" = "Catppuccin Mocha";

          "editor.fontLigatures" = true;

          "editor.lineNumbers" = "relative";
          "editor.acceptSuggestionOnEnter" = "smart";
          "editor.inlineSuggest.enabled" = true;

          "git.confirmSync" = false;

          "direnv.path.executable" = "${pkgs.direnv}/bin/direnv";

          "python.languageServer" = "Pylance";
          "python.formatting.provider" = "ruff";

          "haskell.manageHLS" = "PATH";

          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "${pkgs.nil}/bin/nil";

          "makefile.configureOnOpen" = true;

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
    };
    stylix.targets.vscode.enable = false;

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
