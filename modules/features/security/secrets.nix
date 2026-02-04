# ============================================================================
# Secrets Management Feature
# ============================================================================
# Centralized age-encrypted secret declarations for the entire configuration.
# All secrets are declared here and referenced throughout modules via
# config.age.secrets.<name>.path
# ============================================================================
{ config, lib, ... }:
let
  cfg = config.my.features.security.secrets;
  # Path to secrets directory (relative to this module file)
  secretsPath = ../../../secrets;
in
{
  options.my.features.security.secrets = {
    enable = lib.mkEnableOption "Age-encrypted secrets management" // { 
      default = true;
    };
  };

  config = {
    age.secrets = {

      # ------------------------------------------------------------------------
      # Tailscale VPN
      # ------------------------------------------------------------------------
      # Pre-authentication key for automatic tailnet joining
      # Referenced by: modules/features/network/vpn/tailscale.nix
      tailscale-authkey = {
        file = secretsPath + "/tailscale-authkey.age";
        mode = "600";
        owner = "root";
        group = "root";
      };

      # ----------------------------------------------------------------------
      # Home WiFi (NetworkManager envsubst)
      # ----------------------------------------------------------------------
      wifi-home-envsubst = {
        file = secretsPath + "/wifi-home-envsubst.age";
        mode = "600";
        owner = "root";
        group = "root";
      };
      
    };
  };
}
