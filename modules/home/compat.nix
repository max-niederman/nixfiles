{ config, pkgs, lib, ... }:

let
  mn-distrobox-assemble = pkgs.writeShellApplication {
    name = "mn-distrobox-assemble";

    runtimeInputs = with pkgs; [
      distrobox
    ];

    text =
      let
        usage = pkgs.writeTextFile {
          name = "usage";
          text = ''
            Usage: mn-distrobox-assemble <distrobox-name>
              distrobox-name: name of the distrobox to assemble
                              possible values:
                                - frc
          '';
        };
      in
      ''
        case "$1" in
          frc)
            distrobox create \
              --name frc \
              --image wpilib/ubuntu-base:22.04 \
              --nvidia \
              --volume /etc/static:/etc/static:ro \
              --volume /etc/profiles:/etc/profiles:ro
            exit 0
            ;;
          --help|-h)
            cat ${usage}
            exit 0
            ;;
          *)
            cat ${usage} >&2
            exit 1
            ;;
        esac
      '';
  };
in
{
  config = {
    home.packages = with pkgs; [
      distrobox
      mn-distrobox-assemble
    ];
  };
}
