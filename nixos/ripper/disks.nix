{ disks ? [ "/dev/nvme0n1" "/dev/nvme1n1" ], ... }: {
  disko.devices = {
    disk = {
      nvme0 = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "boot";
              start = "0%";
              end = "1M";
              flags = [ "bios_grub" ];
            }
            {
              name = "ESP";
              start = "1M";
              end = "1024M";
              bootable = true;
              fs-type = "fat32";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            }
            {
              name = "root";
              start = "1024M";
              end = "100%";
              content = {
                type = "filesystem";
                # Overwirte the existing filesystem
                extraArgs = [ "-f" ];
                format = "xfs";
                mountpoint = "/";
              };
            }
          ];
        };
      };
      nvme1 = {
        type = "disk";
        device = builtins.elemAt disks 1;
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "home";
              start = "0%";
              end = "100%";
              content = {
                type = "filesystem";
                # Overwirte the existing filesystem
                extraArgs = [ "-f" ];
                format = "xfs";
                mountpoint = "/home";
              };
            }
          ];
        };
      };
    };
  };
}
