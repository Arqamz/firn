{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  networking.hostName = "zinc";

  wsl.enable = true;
  wsl.defaultUser = "arqam";

  # Enable the 'interactive' role
  my.roles.interactive.enable = true;

  # The VSCode Remote server can not be run as-is on NixOS
  # because it downloads a nodejs binary that requires /lib64/ld-linux-x86-64.so.2
  # to be present, which isn't the case on NixOS.
  # Nix-ld provides the missing loader and allows the server to run.
  programs.nix-ld.enable = true;

  users.users.arqam = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "25.05";
}
