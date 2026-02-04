# ============================================================================
# Agenix Public Key Mappings
# ============================================================================
# 
# This file is consumed by agenix CLI tool for secret creation and rekeying
#
# Key Types:
#   - User keys: Personal SSH keys for secret management operations
#   - Host keys: System SSH keys for runtime secret decryption
#
# Operations:
#   - Create/edit secret:  agenix -e <secret-name>.age
#   - Rekey all secrets:   agenix --rekey
#   - Decrypt manually:    rage -d -i ~/.ssh/id_ed25519 <secret>.age
#
# ============================================================================
let
  # ==========================================================================
  # User Public Key
  # ==========================================================================
  # Personal SSH public key for secret management operations.
  # Users can create, edit, and rekey secrets using their private key.
  #
  # Source: ~/.ssh/id_ed25519.pub
  # For rotation generate a new key pair, add to this file, rekey secrets, update
  # authorized_keys on all hosts, remove old key, rekey again.
  
  arqam = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJCJKE7XUp3zXs98b5aE++nuuNoTVV80dvicI5HF3zzS arqam.mzia@gmail.com";
  
  users = [ arqam ];

  # ==========================================================================
  # Host Public Keys (SSH Host Keys)
  # ==========================================================================
  # System SSH host public keys for runtime secret decryption.
  # NixOS automatically uses these keys via age.identityPaths configuration.
  #
  # Extraction Methods:
  #   Local:  cat /etc/ssh/ssh_host_ed25519_key.pub
  #   Remote: ssh <hostname> cat /etc/ssh/ssh_host_ed25519_key.pub
  #   Scan:   ssh-keyscan <hostname> | grep ed25519
  #
  # Initial Deployment Limitation:
  #   Host keys are generated during first system activation.
  #   Cannot be known before initial deployment.
  #   Bootstrap process: for each host deploy with user keys only
  #   extract host keys, update this file, rekey secrets, redeploy.
  
  platinum = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLrCLEn9gUL5nwmS+d9xum0dHXWZ3BdbBUX11k3pJ2a root@platinum";
  zinc     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPUB82G8QJGcqeahNp8accYDk4pQhHJ3mOSO012tdkqV root@zinc";
  nickel   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTiBav7ZtqVmy+y/mau9qMEdxO12TI9TvMZkSJmuVJY root@nickel";

  # ==========================================================================
  # Host Groups
  # ==========================================================================
  # Logical groupings for secret access control.
  
  # All currently deployed hosts.
  allHosts  = [ platinum nickel zinc ];

  # Hosts that connect to home wifi
  wifiHomeHosts = [ platinum ];

in
{
  # ==========================================================================
  # Secret Definitions
  # ==========================================================================
  # Maps encrypted files to authorized public keys.
  # Format: "<filename>.age".publicKeys = [ <list of public keys> ];
  
  # Tailscale VPN authentication key
  # Centralized tailnet joining control across all hosts
  "tailscale-authkey.age".publicKeys = users ++ allHosts;

  # Home WiFi credentials
  # Secrets are envsubst-style environment files (KEY=VALUE),
  # on a separate line each and substituted into NetworkManager profiles.
  "wifi-home-envsubst.age".publicKeys = users ++ wifiHomeHosts;
}
