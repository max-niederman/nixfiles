{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            zpool = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
            swap = {
              size = "64G";
              content = {
                type = "swap";
              };
            };
            ESP = {
              size = "4G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
          };
        };
      };
    };
    zpool = {
      tank = {
        type = "zpool";
        options = {
          ashift = "12";
        };
        rootFsOptions = {
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "prompt";
          compression = "lz4";
          xattr = "sa";
          acltype = "posix";
          mountpoint = "none";
        };
        datasets = {
          "local" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
          };
          "local/nix" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/nix";
          };
          "safe" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
          };
          "safe/home" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/home";
          };
          "safe/root" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
