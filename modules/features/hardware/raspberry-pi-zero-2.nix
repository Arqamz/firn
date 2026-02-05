# ============================================================================
# Raspberry Pi Zero 2W Hardware Module
# ============================================================================
# Comprehensive hardware configuration for the Raspberry Pi Zero 2W.
#
# This module encapsulates:
#   - Hardware enablement (i2c, firmware)
#   - Device tree configuration with custom overlays
#   - Boot configuration (kernel, initrd, bootloader)
#   - Memory management (zram swap)
#   - VRAM and GPU optimizations for headless operation
#
# Usage in host configuration:
#   my.hardware.rpizero2.enable = true;
#
# For SD image building, also add to host imports:
#   imports = [ "${modulesPath}/installer/sd-card/sd-image-aarch64.nix" ];
#
# Note: The Pi Zero 2W only has 512MB RAM and therefore cannot build itself.
# Use cross-compilation and remote deployment for updates.
# ============================================================================
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.hardware.rpizero2;
in
{
  options.my.hardware.rpizero2.enable = lib.mkEnableOption "Raspberry Pi Zero 2W Hardware";

  config = lib.mkIf cfg.enable {
    
    # ============================================================================
    # Memory Management
    # ============================================================================
    # zram provides compressed swap in RAM, essential for the Pi Zero 2W's
    # limited RAM. Using zram instead of SD card swap extends SD card
    # lifespan by avoiding excessive writes.
    zramSwap = {
      enable = true;
      algorithm = "zstd";
    };

    # ============================================================================
    # Hardware Configuration
    # ============================================================================
    hardware = {
      # Disable redistributable firmware to keep the system minimal
      # Only include essential wireless firmware for WiFi functionality
      enableRedistributableFirmware = lib.mkForce false;
      
      # WiFi firmware is required for the Pi Zero 2W's built-in wireless
      firmware = [ pkgs.raspberrypiWirelessFirmware ];
      
      # Enable I2C bus for hardware interfacing (sensors, displays, etc.)
      i2c.enable = true;

      # Device Tree Configuration
      # -------------------------
      # Enable custom device tree overlays to configure hardware beyond
      # the default Raspberry Pi board setup
      deviceTree = {
        enable = true;

        # Use the Raspberry Pi 3 kernel package:
        # Pi Zero 2 W shares the BCM2710/BCM2837 (ARMv8 Cortex-A53) SoC family
        kernelPackage = pkgs.linuxKernel.packages.linux_rpi3.kernel;

        # Select device trees for BCM2837-class SoCs
        # (used by Raspberry Pi 3 and Pi Zero 2 W)
        filter = "*2837*";

        # Custom overlays enabling additional hardware interfaces
        overlays = [
          {
            name = "enable-i2c";
            dtsFile = ./raspberry-pi-zero-2/dts/i2c.dts;
          }
          {
            name = "pwm-2chan";
            dtsFile = ./raspberry-pi-zero-2/dts/pwm.dts;
          }
          {
            name = "spi1-2cs";
            dtsFile = ./raspberry-pi-zero-2/dts/spi.dts;
          }
        ];
      };
    };

    # ============================================================================
    # Boot Configuration
    # ============================================================================
    boot = {
      # Use the Raspberry Pi Zero 2W optimized kernel
      kernelPackages = pkgs.linuxPackages_rpi02w;

      # Kernel modules required for USB boot and storage
      initrd.availableKernelModules = [
        "xhci_pci"     # USB 3.0 controller
        "usbhid"       # USB human interface devices
        "usb_storage"  # USB mass storage
      ];

      loader = {
        # The Pi uses its own bootloader, not GRUB
        grub.enable = false;
        
        # Use the generic extlinux-compatible bootloader
        # This is standard for ARM devices
        generic-extlinux-compatible.enable = true;
      };

      # Disable software RAID to avoid mdadm warnings
      # See: https://github.com/NixOS/nixpkgs/issues/254807
      # The Pi Zero 2W doesn't use RAID, so this is safe to disable
      swraid.enable = lib.mkForce false;
    };
  };
}