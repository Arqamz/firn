# ============================================================================
# Network Feature Index
# ============================================================================
# Decomposed networking capabilities.
# ============================================================================
{ ... }:
{
  imports = [
    ./dns/resolved.nix
    ./manager/networkmanager.nix
    ./firewall/nftables.nix
    ./vpn/tailscale.nix
  ];
}
