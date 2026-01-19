# ============================================================================
# Power Management Feature
# ============================================================================
# Power management with UPower and tuned.
# Set `mobile = true` for laptop-specific optimizations.
# ============================================================================
{ config, lib, pkgs, ... }:
let
  cfg = config.my.features.power;
in
{
  options.my.features.power = {
    enable = lib.mkEnableOption "Power Management Features";
    mobile = lib.mkEnableOption "Mobile/Laptop optimizations";
  };

  config = lib.mkIf cfg.enable {

    # -- UPower --
    services.upower = {
      enable = true;
      usePercentageForPolicy = true;
      percentageLow = 20;
      percentageCritical = 10;
      percentageAction = 5;
    } // (lib.optionalAttrs cfg.mobile {
      # Laptop specific overrides
      criticalPowerAction = "Hibernate";
      ignoreLid = false;
    }) // (lib.optionalAttrs (!cfg.mobile) {
      # Desktop specific overrides
      criticalPowerAction = "PowerOff";
      ignoreLid = true;
    });

    # -- Tuned --
    services.tuned = {
      enable = true;
    };
    
    # Automatically select a profile based on mobile flag if not explicitly set by user elsewhere
    # profile = lib.mkDefault (if cfg.mobile then "balanced" else "throughput-performance");
  };
}
