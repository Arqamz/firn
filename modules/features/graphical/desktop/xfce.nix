{ config, lib, pkgs, ... }:
let
  cfg = config.my.features.graphical.desktop.xfce;
in
{
  options.my.features.graphical.desktop.xfce.enable = lib.mkEnableOption "XFCE Desktop";

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.desktopManager.xfce.enable = true;
    
    environment.systemPackages = with pkgs; [ 
      xfce4-terminal
      thunar
    ];
  };
}
