{
  lib,
  nixosConfig,
  pkgs,
  ...
}:

{
  config = lib.mkIf nixosConfig.max.development {
    programs.direnv = {
      enable = true;
    };

    # thanks Nilstrieb!
    # mold-wrapped has the cursed nix linker shenanigans that make it produce properly rpathed binaries.
    home.file.".cargo/config.toml".text = ''
      [target.x86_64-unknown-linux-gnu]
      linker = "${lib.getExe pkgs.llvmPackages_21.clang}"
      rustflags = ["-Clink-arg=-fuse-ld=${lib.getExe' pkgs.mold "mold"}", "-Ctarget-cpu=native"]
    '';

    home.packages = with pkgs; [
      claude-code
      codex

      devcontainer

      gh

      lldb
      gdb
      lurk
      hyperfine

      gcc

      python3
      uv
      ruff

      bun
      nodejs

      rustup
      cargo-generate
      cargo-flamegraph
      cargo-depgraph
      cargo-nextest

      nixd
      nil
      alejandra

      ghc
      cabal-install
      haskell-language-server

      jdk

      lean4

      sqlite
      sqlite-utils
      duckdb

      httpie
      postman

      graphviz

      google-cloud-sdk

      beancount # TODO: move to somewhere more appropriate
    ];
  };
}
