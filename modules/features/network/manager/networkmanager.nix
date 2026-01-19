# ============================================================================
# NetworkManager Feature
# ============================================================================
{ config, lib, ... }:
let
  cfg = config.my.features.network.manager;
in
{
  options.my.features.network.manager.enable = lib.mkEnableOption "NetworkManager";

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;
  };
}
