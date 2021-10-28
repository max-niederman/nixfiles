{ config, pkgs, lib, ... }:

{
  max = { };

  # empty initial password
  users.users = {
    max.initialHashedPassword = "EIlwTlxEfyPhc";
    root.initialHashedPassword = "EIlwTlxEfyPhc";
  };

  home-manager.users.max = {
    max = { };
  };
}
