{ config, pkgs, lib, ... }:

{
  config = {
    programs.git = {
      enable = true;

      lfs.enable = true;
      delta.enable = true;

      userEmail = "max@maxniederman.com";
      userName = "Max Niederman";

      signing = {
        key = null; # let GPG decide
        gpgPath = "${config.programs.gpg.package}/bin/gpg2";
        signByDefault = true;
      };

      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };
    programs.gh.enable = true;

    programs.direnv = {
      enable = true;
    };
    services.lorri = {
      enable = true;
    };

    home.packages = with pkgs; [
      git-crypt # transparent file encryption
    ];
  };
}
