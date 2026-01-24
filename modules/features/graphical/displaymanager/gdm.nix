{ config, lib, pkgs, ... }:
let
  cfg = config.my.features.graphical.displaymanager.gdm;
in
{
  options.my.features.graphical.displaymanager.gdm.enable = lib.mkEnableOption "GDM Display Manager";

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
  };
}
