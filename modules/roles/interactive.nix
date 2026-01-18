{ config, lib, pkgs, ... }:
let
  cfg = config.my.roles.interactive;
in
{
  options.my.roles.interactive.enable = lib.mkEnableOption "Interactive Role (CLI/TUI only)";

  config = lib.mkIf cfg.enable {
    
    # Enable ZSH shell feature
    my.features.shell.zsh.enable = lib.mkDefault true;

    # CLI Tools
    environment.systemPackages = with pkgs; [
      microfetch
      yazi
      eza
      zip
      unzip
    ];

  };
}
