# ============================================================================
# Compute Role
# ============================================================================
# This machine is tuned for performance and virtualisation. Appropriate for:
#   - VM hosts
#   - Development workstations
#   - Build servers
#
# This role provides:
#   - Libvirtd virtualisation
#   - Kernel tuning (future)
#   - Performance-oriented sysctl settings (future) 
#   - Custom kernel patches (future)
#
# It does NOT assume graphical capabilities or user interaction.
# ============================================================================
{ config, lib, pkgs, ... }:
let
  cfg = config.my.roles.compute;
in
{
  options.my.roles.compute.enable = lib.mkEnableOption "Compute Role (VMs, Performance)";

  config = lib.mkIf cfg.enable {
    my.features.virtualisation.libvirtd.enable = lib.mkDefault true;
    
    # Kernel tuning and other performance settings could go here
    # boot.kernel.sysctl = { ... };
  };
}
