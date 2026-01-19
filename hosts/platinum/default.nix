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
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ============================================================================
  # System Identity & Locale
  # ============================================================================
  time.timeZone = "Asia/Karachi";

  # ============================================================================
  # Features
  # ============================================================================
  # Graphical
  my.features.graphical.niri.enable = true;
  
  # Audio
  my.features.audio.pipewire.enable = true;
  
  # Network
  my.features.network.enable = true;
  
  # Security
  my.features.security.enable = true;
  my.features.security.passwordlessSudo = true;
  
  # System (boot/locale)
  my.features.system.enable = true;

  # ============================================================================
  # Hardware
  # ============================================================================
  my.hardware.nvidia.enable = true;

  # ============================================================================
  # User Configuration
  # ============================================================================
  users.users.arqam = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "kvm" ];
    packages = with pkgs; [
      # Noctalia shell (from flake input)
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default

      # GUI Applications
      spotify-tray
      vscode
      spotify
      google-chrome
      whatsapp-electron
      vesktop
      obs-studio
      mpv
      nemo
    ];
  };
}
