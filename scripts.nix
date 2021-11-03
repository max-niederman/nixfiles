{ pkgs }:

with pkgs; {
  nixfiles-run = writeShellScriptBin "nixfiles-run" ''
    format_file=$(mktemp -t nixfiles-run.XXXXXX)

    cat <<- "EOF" > $format_file
    { modulesPath, ... }:
    {
      imports = [
        "${"\${toString modulesPath}"}/virtualisation/qemu-vm.nix"
      ];

      virtualisation = {
        forwardPorts = [
          { from = "host"; host.port = 8088; guest.port = 80; }
          { from = "host"; host.port = 8022; guest.port = 22; }
        ];

        resolution = { x = 1920; y = 1080; };

        memorySize = 2048;
        cores = 4;

        qemu.options = [
          "-enable-kvm"
          "-vga virtio"
        ];
      };

      formatAttr = "vm";
    }

    EOF

    nixos-generate --flake .#run --format-path $format_file --run

    rm $format_file
  '';
}
