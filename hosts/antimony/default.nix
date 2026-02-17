# ============================================================================
# Antimony - Laptop Workstation
# ============================================================================
# Laptop running Hyprland compositor with noctalia shell.
# Configured for lightweight mobile usage and overflow workloads.
#
# Hardware:
#   - Intel i7-8550U CPU with UHD 620 iGPU and a 940MX dGPU
#   - Btrfs filesystem with subvolumes (@root, @nix, @persist)
# ============================================================================
{ config, lib, pkgs, inputs, ... }:
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
  
  # Graphical - Hyprland compositor
  my.features.graphical.desktop.hyprland.enable = true;
  
  # Audio
  my.features.audio.pipewire.enable = true;
  
  # Network
  my.features.network = {
    dns.enable = true;
    manager.enable = true;
    firewall.enable = true;
    wifi.home.enable = true;
  };

  # DNS servers must be set manually since the feature doesn't assume them
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  
  # Security - Enables GNUPG agent, OpenSSH server, and sudo settings
  my.features.security = {
    enable = true;
    passwordlessSudo = true;
  };

  # For remote deployment over ssh
  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";
  
  # Tailscale VPN
  my.features.network.vpn.tailscale.enable = true;
  
  # System (boot/locale)
  my.features.system.enable = true;

  # ============================================================================
  # Memory Management
  # ============================================================================
  # Enable zram for RAM compression - provides compressed swap in RAM
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # ============================================================================
  # Services
  # ============================================================================
  
  # NTP time synchronization
  services.timesyncd.enable = true;

  # Auto-login on tty1
  services.getty.autologinUser = "arqam";

  # ============================================================================
  # User Configuration
  # ============================================================================
  users.users.arqam = {
    isNormalUser = true;
    home = "/home/arqam";
    description = "arqam";
    extraGroups = [ 
      "wheel"
      "networkmanager"
    ];

    packages = with pkgs; [
      # Flake inputs
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.default

      # CLI
      license-cli

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
    
    openssh.authorizedKeys.keys = [ 
      config.my.constants.ssh-keys.arqam
    ];
  };
}
