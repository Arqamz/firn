{ config, pkgs, inputs, ... }:
{
  imports = [
    # Include the results of the hardware scan (file systems, kernel modules, etc.)
    ./hardware-configuration.nix
  ];

  # ============================================================================
  # Bootloader Configuration
  # ============================================================================
  boot.loader.systemd-boot.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ============================================================================
  # System Identity & Locale
  # ============================================================================
  time.timeZone = "Asia/Karachi";

  # ============================================================================
  # Features
  # ============================================================================
  # Security
  my.features.security.enable = true;
  
  # Networking
  networking.networkmanager.enable = true;
  
  # ============================================================================
  # Hardware
  # ============================================================================
  # VM/QEMU hardware
  services.qemuGuest.enable = true;
  
  # ============================================================================
  # Desktop Environments / Window Managers
  # ============================================================================
  # You can enable multiple environments simultaneously.
  
  # 1. GNOME
  my.features.graphical.desktop.gnome.enable = true;

  # 2. KDE Plasma 6
  my.features.graphical.desktop.kde.enable = true;

  # 3. Niri
  my.features.graphical.desktop.niri.enable = true;

  # 4. XFCE
  my.features.graphical.desktop.xfce.enable = true;

  # Disable graphical ask password to avoid conflicting values set when both Plasma and Gnome are enabled
  programs.ssh.enableAskPassword = false;

  # ============================================================================
  # Display Manager
  # ============================================================================
  # Select ONE display manager to manage login sessions.
  
  # GDM (Best for GNOME)
  # my.features.graphical.displaymanager.gdm.enable = true;

  # SDDM (Best for KDE)
  my.features.graphical.displaymanager.sddm.enable = true;

  # LightDM (Best for XFCE)
  # my.features.graphical.displaymanager.lightdm.enable = true;

  # Greetd (Minimal and lightweight: using with niri)

  # ============================================================================
  # User Configuration
  # ============================================================================
  users.users.arqam = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  };

}