# ============================================================================
# Firewall Feature
# ============================================================================
{ config, lib, ... }:
let
  cfg = config.my.features.network.firewall;
in
{
  options.my.features.network.firewall.enable = lib.mkEnableOption "Firewall";

  config = lib.mkIf cfg.enable {
    networking.firewall.enable = true;
    networking.firewall.checkReversePath = "loose";
  };
}
