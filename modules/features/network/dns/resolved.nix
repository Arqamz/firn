# ============================================================================
# DNS Feature (systemd-resolved)
# ============================================================================
{ config, lib, ... }:
let
  cfg = config.my.features.network.dns;
in
{
  options.my.features.network.dns.enable = lib.mkEnableOption "systemd-resolved DNS";

  config = lib.mkIf cfg.enable {
    services.resolved.enable = true;
  };
}
