{ config, lib, pkgs, ... }:
let
  cfg = config.my.features.graphical.desktop.kde;
in
{
  options.my.features.graphical.desktop.kde.enable = lib.mkEnableOption "KDE Plasma 6";

  config = lib.mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;
    
    environment.systemPackages = with pkgs; [ 
      kdePackages.kate
      kdePackages.dolphin
      kdePackages.konsole
    ];
  };
}
