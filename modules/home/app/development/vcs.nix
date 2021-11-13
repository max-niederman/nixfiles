{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.max.app.development.vcs;
in
{
  options.max.app.development.vcs = {
    userEmail = mkOption {
      type = types.str;
      default = "max@maxniederman.com";
      description = "Default user email.";
    };

    userName = mkOption {
      type = types.str;
      default = "Max Niederman";
      description = "Default user name.";
    };
  };

  config = mkIf config.max.app.development.enable {
    programs = {
      git = {
        enable = true;

        lfs.enable = true;
        delta.enable = true;

        userEmail = cfg.userEmail;
        userName = cfg.userName;

        signing = {
          key = null; # let GPG decide
          gpgPath = "${config.programs.gpg.package}/bin/gpg2";
          signByDefault = true;
        };

        extraConfig = {
          init.defaultBranch = "main";
          pull.rebase = false;
        };
      };
    };

    home.packages = with pkgs; [
      git-crypt # transparent file encryption
    ];
  };
}
