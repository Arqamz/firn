# ============================================================================
# System Feature
# ============================================================================
# Standard system configuration for boot and locale settings.
# Appropriate for most interactive systems.
#
# This feature provides:
#   - Tmpfs for /tmp with automatic cleanup
#   - US English locale and keyboard layout
# ============================================================================
{ config, lib, ... }:
let
  cfg = config.my.features.system;
in
{
  options.my.features.system = {
    enable = lib.mkEnableOption "Standard System Settings";
  };

  config = lib.mkIf cfg.enable {
    # Clean /tmp on boot and use tmpfs
    boot.tmp.cleanOnBoot = true;
    boot.tmp.useTmpfs = true;
    
    # Basic locale
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "us";
  };
}
