{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  # ============================================================================
  # WSL-Specific Configuration
  # ============================================================================
  wsl.enable = true;
  wsl.defaultUser = "arqam";
          
  # The VSCode Remote server requires /lib64/ld-linux-x86-64.so.2
  # Nix-ld provides the missing loader
  programs.nix-ld.enable = true;

  # ============================================================================
  # Features
  # ============================================================================
  # Security
  my.features.security.enable = true;
  my.features.security.passwordlessSudo = true;

  # ============================================================================
  # User Configuration
  # ============================================================================
  users.users.arqam = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      texliveTeTeX
    ];
  };
}
