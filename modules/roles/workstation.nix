{ config, lib, pkgs, ... }:
let
  cfg = config.my.roles.workstation;
in
{
  options.my.roles.workstation.enable = lib.mkEnableOption "Workstation Role";

  config = lib.mkIf cfg.enable {
    
    # Core workstation features
    my.features.virtualisation.libvirtd.enable = lib.mkDefault true;
    my.features.audio.pipewire.enable = lib.mkDefault true;
    my.features.power.enable = lib.mkDefault true;
    my.features.power.mobile = lib.mkDefault false; # Plugged in
    my.features.shell.zsh.enable = lib.mkDefault true;
    
    hardware.bluetooth.enable = lib.mkDefault true;

    # Common tools for all workstations
    environment.systemPackages = with pkgs; [
      ripgrep
      fd
      jq
      zip
      unzip
      pciutils
      usbutils
      dmidecode
      lshw
    ];

    # Font configuration
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };
}
