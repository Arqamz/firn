{ config, lib, pkgs, ... }:
let
  cfg = config.my.features.graphical.desktop.gnome;
in
{
  options.my.features.graphical.desktop.gnome.enable = lib.mkEnableOption "Gnome Desktop";

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.desktopManager.gnome.enable = true;
    
    environment.systemPackages = with pkgs; [ 
      gnome-tweaks
    ];
  };
}
