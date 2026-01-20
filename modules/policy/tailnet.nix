{ config, lib, ... }:
let
  cfg = config.my.policy.tailnet;
in
{
  options.my.policy.tailnet = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Join the Tailscale mesh network by default";
    };
  };

  config = lib.mkIf cfg.enable {
    my.features.network.vpn.tailscale.enable = true;
  };
}
