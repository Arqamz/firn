# ============================================================================
# Constants Module
# ============================================================================
# Shared public configuration data and constants used across hosts.
# This module contains non-secret, reusable values like:
#   - SSH public keys
#   - Network configurations
#   - Common file paths
#   - Service URLs
#
# Unlike secrets/, this data is public and committed to version control.
# ============================================================================
{ lib, ... }:
{
  imports = lib.recursivelyImport {
    list = [ ./. ];
    exclude = [ ./default.nix ];
  };
}
