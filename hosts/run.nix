{ config, pkgs, lib, ... }:

{
  max = { };

  # empty password
  users.users = lib.genAttrs
    [ "root" "max" ]
    (_: { hashedPassword = "$6$P10pEElkGAi$gEb5VLMWEU7eaudwJLwMTFWgIvHU8Z.KeEiZFP1kgVeRC2mzQ2.qp/TZGHzSE/pf2oHVXH/UQzMEdDQWtrjlv1"; });

  home-manager.users.max = { };
}
