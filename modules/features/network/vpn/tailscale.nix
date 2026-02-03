# ============================================================================
# Tailscale VPN Feature
# ============================================================================
# Provides Tailscale mesh VPN with optional age-encrypted auth key support
# for automatic tailnet joining on first boot.
#
# Usage:
#   # Use default encrypted auth key
#   my.features.network.vpn.tailscale.enable = true;
#
#   # Disable auth key (manual authentication required)
#   my.features.network.vpn.tailscale = {
#     enable = true;
#     useAuthKeySecret = false;
#   };
#
#   # Override with custom auth key
#   my.features.network.vpn.tailscale.useAuthKeySecret = false;
#   services.tailscale.authKeyFile = pkgs.writeText "custom-key" "tskey-...";
# ============================================================================
{ config, lib, pkgs, ... }:
let
  cfg = config.my.features.network.vpn.tailscale;

  authKeyPath =
    if cfg.auth.mode == "agenix" then
      config.age.secrets.tailscale-authkey.path
    else if cfg.auth.mode == "bootstrap" then
      cfg.auth.bootstrapKey
    else
      null;
in
{
  options.my.features.network.vpn.tailscale = {
    enable = lib.mkEnableOption "Tailscale VPN";

    auth = {
      mode = lib.mkOption {
        type = lib.types.enum [ "agenix" "bootstrap" "manual" ];
        default = "agenix";
        description = ''
          How Tailscale authentication is handled:
          - agenix: use the age-encrypted auth key (default)
          - bootstrap: use a provided ephemeral auth key for initial bootstrapping when agenix isn't available
          - manual: no automatic authentication
        '';
      };

      bootstrapKey = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to a temporary Tailscale auth key used only for bootstrapping.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.tailscale.enable = true;

    systemd.services.tailscale-autologin = lib.mkIf (authKeyPath != null) {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" "tailscaled.service" ];
      wants = [ "network-online.target" "tailscaled.service" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;

        ExecStartPre = ''
          ${pkgs.coreutils}/bin/test -f ${authKeyPath}
          for i in $(seq 1 10); do
            ${pkgs.coreutils}/bin/test -S /var/run/tailscale/tailscaled.sock && break
            sleep 0.5
          done
        '';

        ExecStart = ''
          ${pkgs.tailscale}/bin/tailscale up --authkey file:${authKeyPath}
        '';

        # Retry automatically if it fails
        Restart = "on-failure";
        RestartSec = 5;  # wait 5 seconds before retry
        StartLimitBurst = 2;  # max 2 retries
      };
    };
  };
}
