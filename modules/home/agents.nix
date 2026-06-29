{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    # coding tuis
    llm-agents.claude-code
    claudewrap # bundles its own bwrap (store path baked in via BWRAP_PATH)
    codex
  ];

  home.shellAliases = {
    c = "claude";
    cw = "claudewrap";
  };
}
