{
  lib,
  nixosConfig,
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

      settings = {
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
  };
}
