{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    # coding tuis
    llm-agents.claude-code
    claudewrap
    codex
  ];

  home.shellAliases = {
    c = "claude";
    cw = "claudewrap";
  };
}
