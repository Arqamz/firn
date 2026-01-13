{ config, lib, pkgs, ... }:
let
  cfg = config.my.features.desktop.gnome;
in
{
  options.my.features.desktop.gnome.enable = lib.mkEnableOption "Gnome Desktop";

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    
    environment.systemPackages = with pkgs; [ 
        gnome-tweaks
    ];
  };
}
