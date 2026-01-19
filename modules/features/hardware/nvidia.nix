# ============================================================================
# Nvidia Hardware Feature
# ============================================================================
# Nvidia GPU drivers with modesetting and power management.
# ============================================================================
{ config, lib, pkgs, ... }:
let
  cfg = config.my.hardware.nvidia;
in
{
  options.my.hardware.nvidia.enable = lib.mkEnableOption "Nvidia Drivers";

  config = lib.mkIf cfg.enable {
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };    
  };
}
