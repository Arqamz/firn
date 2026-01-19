# ============================================================================
# Tailscale VPN Feature
# ============================================================================
{ config, lib, ... }:
let
  cfg = config.my.features.network.vpn.tailscale;
in
{
  options.my.features.network.vpn.tailscale.enable = lib.mkEnableOption "Tailscale VPN";

  config = lib.mkIf cfg.enable {
    services.tailscale.enable = true;
  };
}
