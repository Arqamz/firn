# ============================================================================
# Server Role
# ============================================================================
# This machine runs services, not interactive sessions. Appropriate for:
#   - Web servers
#   - Database hosts
#   - Build servers
#   - Any headless service machine
#
# This role provides:
#   - Service-first defaults
#   - Minimal UX assumptions
#   - Hardened/stable settings (future)
#
# It explicitly does NOT enable interactive, graphical, or audio features.
# ============================================================================
{ config, lib, pkgs, ... }:
let
  cfg = config.my.roles.server;
in
{
  options.my.roles.server.enable = lib.mkEnableOption "Server Role";

  config = lib.mkIf cfg.enable {
    # Service-first defaults
    # Minimal UX settings
  };
}
