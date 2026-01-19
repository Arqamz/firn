# ============================================================================
# Network Feature
# ============================================================================
# Standard networking configuration with NetworkManager and Tailscale.
# Appropriate for interactive systems that need network connectivity.
#
# This feature provides:
#   - NetworkManager for connection management
#   - systemd-resolved for DNS
#   - Firewall with sane defaults
#   - Tailscale VPN (enabled by default, can be overridden)
# ============================================================================
{ config, lib, ... }:
let
  cfg = config.my.features.network;
in
{
  options.my.features.network = {
    enable = lib.mkEnableOption "Standard Networking";
    tailscale = lib.mkEnableOption "Tailscale VPN" // { default = true; };
  };

  config = lib.mkIf cfg.enable {
    # DNS resolution
    services.resolved.enable = true;
    networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
    
    # Connection management
    networking.networkmanager.enable = true;
    
    # Firewall
    networking.firewall.enable = true;
    networking.firewall.checkReversePath = "loose";

    # Tailscale VPN
    services.tailscale.enable = cfg.tailscale;
  };
}
