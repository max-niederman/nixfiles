{
  lib,
  config,
  pkgs,
  ...
}:

{
  config = {
    programs.git = {
      enable = true;

      lfs.enable = true;

      signing = {
        key = "~/.ssh/id_ed25519.pub";
        signByDefault = true;
      };

      extraConfig = {
        user.email = "max@maxniederman.com";
        user.name = "Max Niederman";

        gpg.format = "ssh";
        gpg.ssh.allowedSignersFile = toString (
          pkgs.writeText "allowed-signers" ''
            max@maxniederman.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINmdKg6WzEiyKysklc3YAKLjHEDLZq4RAjRYlSVbwHs9 max
          ''
        );

        init.defaultBranch = "main";

        pull.rebase = true;
      };
    };

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };

    programs.direnv = {
      enable = true;
    };

    # thanks Nilstrieb!
    # mold-wrapped has the cursed nix linker shenanigans that make it produce properly rpathed binaries.
    home.file.".cargo/config.toml".text = ''
      [target.x86_64-unknown-linux-gnu]
      linker = "${lib.getExe pkgs.llvmPackages_21.clang}"
      rustflags = ["-Clink-arg=-fuse-ld=${lib.getExe' pkgs.mold-wrapped "mold"}", "-Ctarget-cpu=native"]
    '';

    home.packages = with pkgs; [
      claude-code

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
