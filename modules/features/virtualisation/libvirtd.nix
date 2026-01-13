{ config, lib, pkgs, ... }:
let
  cfg = config.my.features.virtualisation.libvirtd;
in
{
  options.my.features.virtualisation.libvirtd.enable = lib.mkEnableOption "Libvirtd Virtualisation";

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = lib.mkDefault pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };

    # dependencies/tools that will be used
    environment.systemPackages = with pkgs; [
      # Core VM management
      virt-manager    # desktop user interface for managing virtual machines via libvirt
      virt-viewer     # UI for displaying the graphical console of a virtual machine
      libvirt         # fundamental toolkit and daemon for managing virtualization platforms
      qemu            # generic and open source machine emulator and virtualizer

      # SPICE display stack (enables high-performance remote desktop/graphics)
      spice           # remote computing solution providing client-server communication
      spice-gtk       # GTK3 widget for SPICE clients, used by virt-manager/virt-viewer
      spice-protocol  # set of protocol headers for SPICE communication

      # Storage & disk tools (useful for managing/preparing VM disk images)
      e2fsprogs       # standard utilities for creating and checking ext2/ext3/ext4 filesystems
      dosfstools      # utilities for working with MS-DOS FAT filesystems (often for EFI partitions)
      ntfs3g          # open source implementation of NTFS for guest disk mounting
      libguestfs      # library for accessing and modifying virtual machine disk images
      guestfs-tools   # command-line tools for inspecting and modifying VM disk contents

      # Networking & inspection
      iproute2        # utilities for controlling TCP/IP networking, routing, and bridges
      iptables        # tools for managing IPv4/IPv6 packet filtering and NAT rules
      ebtables        # ethernet bridge frame table administration for filtered bridging

      # Windows / Secure Boot
      swtpm           # software TPM (Trusted Platform Module) emulator for Secure Boot support
      virtio-win      # ISO containing Windows drivers for optimized VirtIO networking and storage

      # Performance / scaling
      numactl         # tool to control NUMA policy for processes or shared memory segments
      hwloc           # portable hardware locality for managing CPU/memory affinity
    ];
  };
}
