# ============================================================================
# Roles Module Index
# ============================================================================
# Roles define *what kind of machine* this is.
#
# Available roles:
#   - interactive: A human actively uses this system (shell, CLI, TUI)
#   - mobile: Battery-powered, portable (power management, backlight)
#   - compute: Performance/VM oriented (virtualisation, kernel tuning)
#   - server: Service-first, non-interactive (minimal UX, hardened)
#
# Roles are orthogonal - combine them as needed:
#   - Desktop: interactive + compute
#   - Laptop: interactive + mobile
#   - WSL: interactive
#   - VM Host: server + compute
# ============================================================================
{ ... }:
{
  imports = [
    ./interactive.nix
    ./mobile.nix
    ./compute.nix
    ./server.nix
  ];
}
