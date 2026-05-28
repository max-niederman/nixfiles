{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    # coding tuis
    llm-agents.claude-code
    claudewrap
    bubblewrap # claudewrap shells out to `bwrap`; uses unprivileged user namespaces
    codex
  ];

  home.shellAliases = {
    c = "claude";
    cw = "claudewrap";
  };
}
