#!/bin/bash

sudo mkdir -p /mnt

sudo zpool import -f tank
sudo zfs load-key -a

sudo mount.zfs tank/safe/root /mnt
sudo mount.zfs tank/safe/home /mnt/home
sudo mount.zfs tank/local/nix /mnt/nix
sudo mount /dev/disk/by-uuid/6AB6-91BB /mnt/boot

sudo $(which nixos-install) --root /mnt --flake .#tar-elendil --no-root-passwd

sudo rm -rf /mnt/home/max/nixfiles
sudo cp -r . /mnt/home/max/nixfiles

sudo umount -fl /mnt/home
sudo umount -fl /mnt/nix
sudo umount -fl /mnt

sudo zpool export tank