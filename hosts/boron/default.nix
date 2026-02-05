# ============================================================================
# Boron - Raspberry Pi Zero 2W
# ============================================================================
# A headless Raspberry Pi Zero 2W running NixOS for lightweight services.
#
# Hardware:
#   - SoC: Broadcom BCM2837 (ARM Cortex-A53, 1GHz quad-core)
#   - RAM: 512MB LPDDR2
#   - Wireless: 802.11 b/g/n WiFi, Bluetooth 4.2 BLE
#   - GPIO: 40-pin header with I2C, SPI, PWM support
#
# ============================================================================
{ config, lib, pkgs, modulesPath, ... }:
{
  # ============================================================================
  # Imports
  # ============================================================================
  imports = [
    # Base SD image configuration for aarch64
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
  ];

  # ============================================================================
  # Workarounds
  # ============================================================================
  # WORKAROUND: Bypass missing AHCI modules on Raspberry Pi
  # The Pi's kernel configuration is missing some AHCI (SATA) modules that
  # NixOS's module closure builder expects. This overlay allows the build to
  # proceed by skipping the missing modules check.
  # See: https://discourse.nixos.org/t/does-pkgs-linuxpackages-rpi3-build-all-required-kernel-modules/42509
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  # ============================================================================
  # Nix Configuration
  # ============================================================================
  # Remote deployment requires trusted users for system activation
  nix.settings.trusted-users = [ "@wheel" ];

  # ============================================================================
  # Hardware Configuration
  # ============================================================================
  my.hardware.rpizero2.enable = true;

  # ============================================================================
  # SD Image Configuration
  # ============================================================================
  # Configure the SD card image for flashing to the Raspberry Pi
  # The sd-image module from nixpkgs already provides the base options
  
  # Set custom image filename
  image = {
    baseName = lib.mkForce "boron";
    fileName = lib.mkForce "boron.img";
  };
  
  sdImage = {
    # Disable bzip2 compression to speed up image builds during cross-compilation
    compressImage = false;
    
    # Append extra Raspberry Pi firmware configuration to config.txt
    populateFirmwareCommands = lib.mkAfter ''
      config=firmware/config.txt
      chmod u+w $config
      echo "" >> $config
      echo "# Extra Raspberry Pi configuration" >> $config
      echo "start_x=0" >> $config      # Disable camera subsystem
      echo "gpu_mem=16" >> $config     # Minimum GPU memory
      echo "hdmi_group=2" >> $config   # DMT (Display Monitor Timings)
      echo "hdmi_mode=8" >> $config    # 800x600 @ 60Hz
      chmod u-w $config
    '';
  };

  # ============================================================================
  # Features
  # ============================================================================
  
  # Enable security features (SSH, sudo, etc.)
  my.features.security = {
    enable = true;
    passwordlessSudo = true;  # Required for remote nixos-rebuild
  };

  # NetworkManager for WiFi + USB Ethernet
  my.features.network.manager.enable = true;
  my.features.network.wifi.home.enable = true;

  # ============================================================================
  # Networking
  # ============================================================================
  networking = {
    # Configure firewall to only allow access via Tailscale
    # This provides secure remote access without exposing services
    firewall = {
      enable = true;
      # Trust all traffic from Tailscale interface
      trustedInterfaces = [ "tailscale0" ];
      # No ports exposed to public/local WiFi network
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };
  
  # ============================================================================
  # Services
  # ============================================================================
  # SSH server for remote access
  services.openssh = {
    enable = true;
    settings = {
      # Disable password authentication - key-based auth only
      PasswordAuthentication = lib.mkForce false;
      KbdInteractiveAuthentication = lib.mkForce false;
    };
  };

  # Tailscale VPN
  services.tailscale.openFirewall = true;

  # ============================================================================
  # Bootstrap Configuration
  # ============================================================================
  # Provisioning logic for initial deployment before host keys exist.
  #
  # Issue: Agenix secrets depend on SSH host keys for decryption. These keys
  # are generated on first boot, making encrypted secrets inaccessible during
  # the initial image build/flash cycle.
  #
  # Resolution: Temporarily inject unencrypted credentials to enable network
  # connectivity and Tailscale registration.
  #
  # Workflow:
  # 1. Uncomment blocks below and populate raw credentials.
  # 2. Flash and boot; host keys will be generated.
  # 3. Connect via ssh using tailscale hostname.
  # 3. Retrieve `/etc/ssh/ssh_host_ed25519_key.pub`.
  # 4. Rekey secrets and revert this configuration to managed state.

  # Ephemeral Tailscale Auth Key
  # my.features.network.vpn.tailscale = {
  #   enable = true;
  #   auth.mode = "bootstrap";
  #   auth.bootstrapKey = pkgs.writeText "ts-bootstrap-key" "tskey-ephemeral-...";
  # };

  # Ephemeral WiFi Configuration
  # networking.networkmanager.ensureProfiles.profiles = {
  #   bootstrap-wifi = {
  #     connection = {
  #       id = "bootstrap-wifi";
  #       type = "wifi";
  #       autoconnect = true;
  #     };
  #     wifi = {
  #       mode = "infrastructure";
  #       ssid = "SSID_PLACEHOLDER";
  #     };
  #     wifi-security = {
  #       key-mgmt = "wpa-psk";
  #       psk = "PSK_PLACEHOLDER";
  #     };
  #   };
  # };
  
  # NTP time synchronization
  services.timesyncd.enable = true;

  # Auto-login on serial console
  services.getty.autologinUser = "arqam";
  
  # ============================================================================
  # System Identity & Locale
  # ============================================================================
  time.timeZone = "Asia/Karachi";
  i18n.defaultLocale = "en_US.UTF-8";

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
      microfetch
      toybox
      sl
    ];
    
    openssh.authorizedKeys.keys = [ 
      config.my.constants.ssh-keys.arqam
    ];
  };
}
