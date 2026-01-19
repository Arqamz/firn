# ============================================================================
# Nix Core Settings
# ============================================================================
# Universal Nix configuration applied to every system.
# These settings enable flakes, optimize storage, and set up garbage collection.
{ pkgs, ... }:
{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;
  
  # Absolute minimum packages required for any NixOS system
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];
}
