{ config, lib, pkgs, ... }:
let
  cfg = config.my.roles.laptop;
in
{
  options.my.roles.laptop.enable = lib.mkEnableOption "Laptop Role";

  # Reuses workstation defaults with some overrides for now — to be improved
  config = lib.mkIf cfg.enable {

    # Often a laptop will just be a workstation that moves
    my.roles.workstation.enable = lib.mkDefault true;
    
    # Enable mobile power management
    my.features.power.enable = true;
    my.features.power.mobile = true;
    
    # Backlight control
    programs.light.enable = true;
  };
}
