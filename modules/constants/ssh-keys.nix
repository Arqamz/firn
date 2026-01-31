# ============================================================================
# SSH Public Keys
# ============================================================================
# Centralized storage for SSH public keys to be used across hosts.
#
# Usage in host configurations:
#   openssh.authorizedKeys.keys = [ config.my.constants.ssh-keys.arqam ];
# ============================================================================
{ config, lib, ... }:
{
  options.my.constants.ssh-keys = {
    arqam = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJCJKE7XUp3zXs98b5aE++nuuNoTVV80dvicI5HF3zzS arqam.mzia@gmail.com";
      description = "Primary SSH public key for arqam user";
    };
  };
}
