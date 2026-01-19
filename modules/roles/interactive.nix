# ============================================================================
# Interactive Role
# ============================================================================
# A human actively uses this system. This role is appropriate for:
#   - Desktops, laptops, and workstations
#   - WSL/Darwin instances
#   - SSH-accessed development machines
#
# This role provides:
#   - Shell configuration (zsh default with powerlevel10k)
#   - CLI tools (ripgrep, fd, jq, yazi, eza, etc.)
#   - Terminal fonts
#   - TUI utilities
#
# It does NOT assume graphical capabilities, audio, or hardware features.
# ============================================================================
{ config, lib, pkgs, ... }:
let
  cfg = config.my.roles.interactive;
in
{
  options.my.roles.interactive.enable = lib.mkEnableOption "Interactive Role";

  config = lib.mkIf cfg.enable {
    
    # Enable ZSH shell feature
    my.features.shell.zsh.enable = lib.mkDefault true;

    # CLI Tools
    environment.systemPackages = with pkgs; [
      # Archive utilities
      zip
      unzip
      
      # Search and find
      ripgrep
      fd
      jq
      
      # System inspection
      pciutils
      usbutils
      dmidecode
      lshw
      htop
      
      # File management
      yazi
      eza
      
      # QOL
      microfetch
    ];

    # Font configuration for terminals
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];

  };
}
