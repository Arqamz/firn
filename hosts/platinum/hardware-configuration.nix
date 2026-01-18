{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # UUID for swap device (hibernate mode) since labels (/dev/disk/swap/) are not guaranteed to exist in early initramfs
  boot.kernelParams = [ "resume=UUID=c78fd22d-8d8e-487e-b4ae-9f3272295039" ];

  fileSystems."/" =
    { device = "/dev/mapper/vg0-lv--root";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/EE1B-C219";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/nix" =
    { device = "/dev/mapper/vg0-lv--nix";
      fsType = "ext4";
      options = [ "noatime" ];
    };

  fileSystems."/persist" =
    { device = "/dev/mapper/vg0-lv--persist";
      fsType = "ext4";
      options = [ "noatime" ];
    };

  fileSystems."/home" =
    { device = "/dev/mapper/vg0-lv--home";
      fsType = "ext4";
    };

  swapDevices = [ 
    { label = "swap"; 
      discardPolicy = "once";
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
