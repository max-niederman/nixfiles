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
      delta.enable = true;

      userEmail = "max@maxniederman.com";
      userName = "Max Niederman";

      signing = {
        key = "~/.ssh/id_ed25519.pub";
        signByDefault = true;
      };

      extraConfig = {
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

      gh

      lldb
      gdb
      lurk
      hyperfine

      gcc

      python3
      uv
      ruff

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

      nixpkgs-fmt

      sqlite
      sqlite-utils

      httpie

      graphviz
    ];
  };
}
