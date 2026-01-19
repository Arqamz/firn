# ============================================================================
# Security Feature
# ============================================================================
# Standard security configuration with SSH, GPG agent, and sudo settings.
# Appropriate for interactive systems that need remote access.
#
# This feature provides:
#   - OpenSSH server with secure defaults
#   - GnuPG agent with SSH support
#   - Passwordless sudo for wheel group (convenience setting)
# ============================================================================
{ config, lib, pkgs, ... }:
let
  cfg = config.my.features.security;
in
{
  options.my.features.security = {
    enable = lib.mkEnableOption "Standard Security Settings";
    ssh = lib.mkEnableOption "OpenSSH Server" // { default = true; };
    gpgAgent = lib.mkEnableOption "GnuPG Agent" // { default = true; };
    passwordlessSudo = lib.mkEnableOption "Passwordless sudo for wheel" // { default = false; };
  };

  config = lib.mkIf cfg.enable {
    # Passwordless sudo (convenience, disable soon for production)
    security.sudo.wheelNeedsPassword = !cfg.passwordlessSudo;
    
    # GnuPG agent with SSH support
    programs.gnupg.agent = lib.mkIf cfg.gpgAgent {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };

    # OpenSSH server
    services.openssh = lib.mkIf cfg.ssh {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
      };
    };
  };
}
