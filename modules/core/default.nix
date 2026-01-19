# ============================================================================
# Core Module
# ============================================================================
# The absolute minimum configuration applied to every NixOS system.
# This should contain ONLY settings that are universally required.
# Everything else belongs in features/ or roles/.
{ ... }:
{
  imports = [
    ./nix.nix
  ];
}
