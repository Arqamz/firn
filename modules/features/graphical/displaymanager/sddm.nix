{ config, lib, pkgs, ... }:
let
  cfg = config.my.features.graphical.displaymanager.sddm;
in
{
  options.my.features.graphical.displaymanager.sddm.enable = lib.mkEnableOption "SDDM Display Manager";

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
  };
}
