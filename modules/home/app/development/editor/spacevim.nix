{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.app.development.editor.spacevim;
  spacevim_config = {
    options = {
      automatic_update = true;

      bootstrap_before = "bootstrap#before";
      bootstrap_after = "bootstrap#after";

      lint_engine = "ale";

      project_rooter_automatically = false;
      filemanager = "nerdtree";

      colorscheme = "nord";
      colorscheme_bg = "dark";
      enable_guicolors = true;

      statusline_separator = "arrow";
      statusline_iseparator = "arrow";
      buffer_index_type = 4;
      enable_tabline_filetype_icon = true;
      enable_statusline_mode = false;
    };

    layers = [
      # VCS

      { name = "VersionControl"; }
      { name = "git"; }
      { name = "github"; }

      # Language

      {
        name = "autocomplete";
        auto_completion_return_key_behavior = "smart";
        auto_completion_tab_key_behavior = "smart";
      }

      {
        name = "lsp";
        filetypes = [
          "astro"
          "c"
          "cpp"
          "css"
          "haskell"
          "html"
          "javascript"
          "json"
          "python"
          "rust"
          "sass"
          "scss"
          "sh"
          "svelte"
          "typescript"
        ];
        override_cmd = {
          astro = [ "astro-ls" ];
          css = [ "vscode-css-language-server" ];
          haskell = [ "haskell-language-server-wrapper" ];
          html = [ "vscode-html-language-server" ];
          json = [ "vscode-json-language-server" ];
          rust = [ "rust-analyzer" ];
          sass = [ "vscode-css-language-server" ];
          scss = [ "vscode-css-language-server" ];
          svelte = [ "svelteserver" ];
        };
      }

      { name = "lang#c"; }
      { name = "lang#dockerfile"; }
      { name = "lang#graphql"; }
      { name = "lang#haskell"; }
      { name = "lang#html"; }
      { name = "lang#javascript"; }
      { name = "lang#latex"; }
      { name = "lang#markdown"; }
      { name = "lang#python"; }
      { name = "lang#rust"; }
      { name = "lang#toml"; }
      { name = "lang#typescript"; }
      { name = "lang#vim"; }
      { name = "lang#extra"; }

      # Utilities

      { name = "test"; }
      { name = "denite"; }
      { name = "shell"; default_position = "left"; }
      { name = "sudo"; }
      { name = "colorscheme"; }
    ];

    custom_plugins = [
      { repo = "evanleck/vim-svelte"; }
      { repo = "wakatime/vim-wakatime"; }
      { repo = "ryanoasis/vim-devicons"; }
    ];
  };
in
{
  options.max.app.development.editor.spacevim = {
    enable = mkEnableOption "Enable Spacevim.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ (spacevim.override { inherit spacevim_config; }) ];
  };
}
