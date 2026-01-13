{ config, pkgs, inputs, ... }:
{
  imports = [
    # Include the results of the hardware scan (file systems, kernel modules, etc.)
    ./hardware-configuration.nix
  ];

  # ============================================================================
  # Bootloader Configuration
  # ============================================================================
  # Use systemd-boot as the bootloader
  boot.loader.systemd-boot.enable = true;
  # Allow modifying EFI variables (required for bootloader and entry management)
  boot.loader.efi.canTouchEfiVariables = true;
  # Use the latest available linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ============================================================================
  # System Identity & Locale
  # ============================================================================
  # Network hostname. (Technically already set in mkSystem, but redefined here for clarity)
  networking.hostName = "platinum"; 
  # Local time zone
  time.timeZone = "Asia/Karachi";

  # ============================================================================
  # Roles & Features (Custom Modules)
  # ============================================================================
  # These options are defined in ../modules and toggle complex configurations
  # to keep this host file clean and declarative.

  # Enable the 'workstation' role (bundles common desktop tools, fonts, etc.)
  my.roles.workstation.enable = true;
  
  # Enable the Niri (Wayland scrollable tiling compositor) desktop environment
  my.features.desktop.niri.enable = true;
  
  # Enable Nvidia drivers and associated hardware acceleration
  my.hardware.nvidia.enable = true;

  # Additional services can be enabled/overridden here

  # ============================================================================
  # User Configuration
  # ============================================================================
  users.users.arqam = {
    isNormalUser = true;
    # Extra groups for permission management:
    # - wheel: Enable sudo privileges
    # - libvirtd/kvm: Managed virtualization permissions
    extraGroups = [ "wheel" "libvirtd" "kvm"];
    
    # User-specific packages installed into the user's profile
    packages = with pkgs; [
      # -- CLI Tools --
      microfetch 
      yazi 
      eza 
      
      # -- GUI Applications --
      spotify-tray
      vscode 
      spotify 
      google-chrome 
      whatsapp-electron 
      vesktop
      obs-studio 
      mpv 
      nemo
      
      # -- Flake Inputs --
      # Accessing packages from external flakes (that are part of the flake inputs)
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  # ============================================================================
  # System State Version
  # ============================================================================
  system.stateVersion = "25.11";
}
