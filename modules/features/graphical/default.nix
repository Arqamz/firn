# ============================================================================
# Graphical Feature Index
# ============================================================================
# Desktop environments and window managers.
# Only one compositor can be enabled at a time.
#
# Available options:
#   - niri: Scrollable tiling Wayland compositor
#   - gnome: Full GNOME desktop environment
# ============================================================================
{ config, lib, ... }:
{
  imports = [
    ./gnome.nix
    ./niri.nix
  ];

  config = {
    assertions = [
      {
        assertion = !(config.my.features.graphical.gnome.enable && config.my.features.graphical.niri.enable);
        message = "Cannot enable both Gnome and Niri Simultaneously. Please enable only one desktop environment.";
      }
    ];
  };
}
