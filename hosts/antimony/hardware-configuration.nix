{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2BF6-843E";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/18a0bb89-14b0-419b-8cea-787f32fbb1c9";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/18a0bb89-14b0-419b-8cea-787f32fbb1c9";
      fsType = "btrfs";
      options = [ "subvol=@root" ];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-uuid/18a0bb89-14b0-419b-8cea-787f32fbb1c9";
      fsType = "btrfs";
      options = [ "subvol=@persist" ];
    };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}