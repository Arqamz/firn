# ============================================================================
# Module Tree Root
# ============================================================================
# This is the entry point for all custom NixOS modules.
#
# Structure:
#   - core/: Absolute minimum settings for any NixOS system (nix settings)
#   - features/: Capabilities that can be enabled (graphical, audio, etc.)
#   - roles/: Machine identity/intent (interactive, mobile, compute, server)
#
# This module is automatically imported by lib/mkSystem for every host.
# ============================================================================
{ ... }:
{
  imports = [
    ./core
    ./features
    ./policy
    ./roles
  ];
}
