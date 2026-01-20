# ============================================================================
# Features Module Index
# ============================================================================
# Features define *what capabilities* are enabled on a system.
#
# Available features:
#   - graphical/: Desktop environments and compositors (niri, gnome)
#   - audio/: Sound systems (pipewire)
#   - shell/: Shell configurations (zsh)
#   - virtualisation/: VM support (libvirtd)
#   - power/: Power management (upower, tuned)
#   - hardware/: Hardware-specific drivers (nvidia)
#   - network/: Networking with NetworkManager/Tailscale
#   - security/: SSH, GPG agent, sudo settings
#   - system/: Boot and locale settings
#
# Features are narrow, composable, and implementation-focused.
# They do NOT assume any role - enable them explicitly for a host or via roles.
# ============================================================================
{ lib, ... }:
{
  imports = lib.recursivelyImport {
    list = [ ./. ];
    exclude = [ ./default.nix ];
  };
}
