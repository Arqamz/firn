{ config, lib, pkgs, ... }:
let
  cfg = config.my.features.graphical.displaymanager.lightdm;
in
{
  options.my.features.graphical.displaymanager.lightdm.enable = lib.mkEnableOption "LightDM Display Manager";

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.lightdm.enable = true;
  };
}
