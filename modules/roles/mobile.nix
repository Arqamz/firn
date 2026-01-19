# ============================================================================
# Mobile Role
# ============================================================================
# This machine is battery-powered and portable. Appropriate for:
#   - Laptops
#   - Tablets
#   - Any device that moves
#
# This role provides:
#   - Power management (UPower, tuned)
#   - Suspend/hibernate configuration
#   - Backlight control
#   - Mobile-optimised power policies
#
# It does NOT assume graphical capabilities.
# ============================================================================
{ config, lib, pkgs, ... }:
let
  cfg = config.my.roles.mobile;
in
{
  options.my.roles.mobile.enable = lib.mkEnableOption "Mobile Role (Laptop/Portable)";

  config = lib.mkIf cfg.enable {
    my.features.power.enable = lib.mkDefault true;
    my.features.power.mobile = lib.mkDefault true;
    
    # Backlight control
    programs.light.enable = lib.mkDefault true;
  };
}
